using System;

namespace savepoints
{
    class Program
    {
        static void Main(string[] args)
        {

            

            Console.WriteLine("Hello World!");
        }
private static void ExecuteSqlTransaction(string connectionString)
{
    using (SqlConnection connection = new SqlConnection(connectionString))
    {
        connection.Open();

        SqlCommand command = connection.CreateCommand();
        SqlTransaction transaction;

        // Start a local transaction.
        transaction = connection.BeginTransaction("SampleTransaction");

        // Must assign both transaction object and connection
        // to Command object for a pending local transaction
        command.Connection = connection;
        command.Transaction = transaction;

        try
        {
            command.CommandText =
                "Insert into Region (RegionID, RegionDescription) VALUES (100, 'Description')";
            command.ExecuteNonQuery();

            transaction.Save("FirstRegionInserted");

            command.CommandText =
                "Insert into Region (RegionID, RegionDescription) VALUES (101, 'Description')";
            command.ExecuteNonQuery();

            // Rollback to a savepoint
            transaction.Rollback("FirstRegionInserted");

            // Only first insert will be considered
            // Attempt to commit the transaction.
            transaction.Commit();
            Console.WriteLine("Only first insert is written to database.");
        }
        catch (Exception ex)
        {
            Console.WriteLine("Commit Exception Type: {0}", ex.GetType());
            Console.WriteLine("  Message: {0}", ex.Message);

            // Attempt to roll back the transaction.
            try
            {
                transaction.Rollback("SampleTransaction");
            }
            catch (Exception ex2)
            {
                // This catch block will handle any errors that may have occurred
                // on the server that would cause the rollback to fail, such as
                // a closed connection.
                Console.WriteLine("Rollback Exception Type: {0}", ex2.GetType());
                Console.WriteLine("  Message: {0}", ex2.Message);
            }
        }
    }
}
    }
}
