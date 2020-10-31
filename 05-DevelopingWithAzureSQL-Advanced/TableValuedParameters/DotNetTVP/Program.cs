using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;

namespace DotNetTVP
{
    class Program
    {
        static void Main(string[] args)
        {
            var tags = new DataTable("PostTagsTableType");
            tags.Columns.Add("Tag", typeof(string));
            tags.Rows.Add("azure-sql");
            tags.Rows.Add("tvp");

            using(var conn = new SqlConnection(Environment.GetEnvironmentVariable("CS_AzureSQL")))
            {
                var cmd = new SqlCommand("dbo.AddTagsToPost", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                var p1 = new SqlParameter("@PostId", SqlDbType.Int);
                p1.Value = 1;
                cmd.Parameters.Add(p1);

                var p2 = new SqlParameter("@Tags", SqlDbType.Structured);
                p2.TypeName = "dbo.PostTagsTableType";
                p2.Value = tags;
                cmd.Parameters.Add(p2);

                conn.Open();                
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
    }
}
