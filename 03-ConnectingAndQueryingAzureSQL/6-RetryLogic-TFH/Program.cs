using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.TransientFaultHandling;
using Microsoft.Extensions.Configuration;

namespace retrylogictfh
{
    class Program
    {
        static async Task Main(string[] args)
        {
            // Reading configuration file
            IConfiguration configuration = new ConfigurationBuilder()
                .AddJsonFile("app.json") 
                .Build();
            // Get retry strategy from configuration
            RetryStrategy retryStrategy = 
                configuration.GetRetryStrategies<FixedInterval>()
                    ["MyFixedStrategy"]; 
            // Create retry policy based on custom transient detection
            // class and retry strategy
            RetryPolicy retry = 
                new RetryPolicy<MyTransientErrorDetection>(retryStrategy);
            // Subscribe to retrying event to intercept
            // when retry logic is retrying an operation
            retry.Retrying += retrying_event;
            // Wrap database interaction with retry policy
            await retry.ExecuteAsync(async () => {
                await MyDatabaseOperation();
             });
        }
        private static void retrying_event(object sender, RetryingEventArgs e)
        {
            SqlException esql = (SqlException)e.LastException;
            // Logging purposes
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine("[{0}] -- Retry #: {1} --"+
                    " SQL Error: {2} -- Exception Message: {3} \n", 
                    DateTime.Now.ToUniversalTime(), 
                    e.CurrentRetryCount, esql.Number, esql.Message);
            Console.ForegroundColor = ConsoleColor.White;
        }
        private static async Task MyDatabaseOperation()
        {
                // Effective database interaction code
                using (SqlConnection cnn = 
                    new SqlConnection(
                    "Server=tcp:<servername>.database.windows.net,"+
                    "1433;Initial Catalog=WideWorldImporters-Full;"+
                    "User ID=<username>;Password=<password>;"+
                    "Connect Timeout=10;"))
                {
                    
                    SqlCommand cmd = new SqlCommand
                    // table doesn’t exist – raise error!
                    ("SELECT * FROM sysobjectz",cnn);
                                    await cnn.OpenAsync();                                
                                    await cmd.ExecuteReaderAsync();
                }
        }
    }
    class MyTransientErrorDetection : ITransientErrorDetectionStrategy
    {
        // Custom transient detection logic, add your own errors
        private List<int> _retriableErrors = new List<int>
         {
            1204,  
            1205, 
            1222, 
            49918,
            49919,
            49920,
            4060, 
            4221, 
            40143,
            40613,
            40501,
            40540,
            40197,
            10929,
            10928,
            10060,
            10054,
            10053,
            233,  
            208,
            64,
            20,
            0
            };
        public bool IsTransient(Exception ex)
        {
            // Detect if error is transient or permanent
            bool retriable = false;            
            if (ex != null)
            {
                SqlException sqlException;
                if ((sqlException = ex as SqlException) != null)
                {
                    foreach (SqlError err in sqlException.Errors)
                    {
                        retriable = _retriableErrors.Contains(err.Number);
                        if (retriable) break;
                    }
                    return retriable;
                }
                else if (ex is TimeoutException)
                {
                    return true;
                }
            }            
            return false;
        }
    }
}