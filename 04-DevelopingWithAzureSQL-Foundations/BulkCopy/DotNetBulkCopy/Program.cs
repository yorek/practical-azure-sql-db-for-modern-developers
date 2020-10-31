using System;
using System.Linq;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Diagnostics;
using Bogus;
using DotNetEnv;

namespace DotNetBulkCopy
{
    class Program
    {
        static void Main(string[] args)
        {
            DotNetEnv.Env.Load();

            Console.WriteLine("Generating sample data...");
            var dt = new DataTable("Users");
            dt.Columns.Add("Id", typeof(int));
            dt.Columns.Add("FirstName", typeof(string));
            dt.Columns.Add("LastName", typeof(string));
            dt.Columns.Add("UserName", typeof(string));
            dt.Columns.Add("Email", typeof(string));

            var faker = new Faker("en");
            int totalRows = 100000;   
            foreach(var i in Enumerable.Range(1, totalRows))
            {
                var dr = dt.NewRow();
                dr["Id"] = i;
                dr["FirstName"] = faker.Name.FirstName();
                dr["LastName"] = faker.Name.LastName();
                dr["UserName"] = faker.Internet.UserName();
                dr["Email"] = faker.Internet.Email();
                dt.Rows.Add(dr);
            }

            Console.WriteLine("Bulk loading into Azure SQL...");
            var sw = new Stopwatch();
            using(var conn = new SqlConnection(Environment.GetEnvironmentVariable("CS_AzureSQL")))
            {
                conn.Open();   
                
                var cmd = new SqlCommand("TRUNCATE TABLE dbo.BulkLoadedUsers", conn);
                cmd.ExecuteNonQuery();

                using (var bc = new SqlBulkCopy(conn))
                {
                    bc.DestinationTableName = "dbo.BulkLoadedUsers";
                    bc.BatchSize = 10000;                
                    bc.NotifyAfter = 5000;
                    bc.SqlRowsCopied += new SqlRowsCopiedEventHandler(BulkCopyNotificationHandler);
                    try
                    {                                                                 
                        sw.Start();
                        bc.WriteToServer(dt);
                        sw.Stop();
                        double elapsedSecs = sw.ElapsedMilliseconds / 1000.0;
                        double rowsPerSec = (double)totalRows / elapsedSecs;
                        Console.WriteLine($"Total elapsed seconds: {elapsedSecs:#.##}");
                        Console.WriteLine($"Rows Per Sec: {rowsPerSec:#.##}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
            }
        }

        static void BulkCopyNotificationHandler(object sender, SqlRowsCopiedEventArgs e)
        {
            Console.WriteLine($"{e.RowsCopied} Rows copied...");
        }

    }
}
