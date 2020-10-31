using System;
using System.Reflection;
using DbUp;

namespace AzureSQLDevelopers.Database.Deploy
{
    class Program
    {
        static int Main(string[] args)
        {
            DotNetEnv.Env.Load();

            var connectionString = Environment.GetEnvironmentVariable("ConnectionString");

            var upgrader = DeployChanges.To
                .SqlDatabase(connectionString)
                .JournalToSqlTable("dbo", "$__schema_journal")
                .WithScriptsFromFileSystem("./sql")                                
                .LogToConsole()
                .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.WriteLine(result.Error);
                return -1;
            }

            Console.WriteLine("Success!");
            return 0;
        }
    }
}
