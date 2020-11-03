using System;
using System.Data.SqlClient;

namespace disttran
{
    class Program
    {
        static string connStrDb1="Server=tcp:<servername>.database.windows.net,1433;Initial Catalog=db1;Persist Security Info=False;User ID=<username>;Password=<password>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        static string connStrDb2="Server=tcp:<servername>.database.windows.net,1433;Initial Catalog=db2;Persist Security Info=False;User ID=<username>;Password=<password>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        static void Main(string[] args)
        {
            using (var scope = new TransactionScope())
            {
                using (var conn1 = new SqlConnection(connStrDb1))
                {
                    conn1.Open();
                    SqlCommand cmd1 = conn1.CreateCommand();
                    cmd1.CommandText = string.Format("INSERT INTO tab1 VALUES(1,'aaa');");
                    cmd1.ExecuteNonQuery();
                }

                using (var conn2 = new SqlConnection(connStrDb2))
                {
                    conn2.Open();
                    var cmd2 = conn2.CreateCommand();
                    cmd2.CommandText = string.Format("INSERT INTO tab1 VALUES(1,'aaa')");
                    cmd2.ExecuteNonQuery();
                }

                scope.Complete();
            }
    }
    }
}
