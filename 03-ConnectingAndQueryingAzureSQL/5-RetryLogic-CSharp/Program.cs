using System;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;

namespace retrylogic
{
    class Program
    {
        static async Task Main(string[] args)
        {
            bool success = false;  
            int retryCount = 3;  
            int retryInterval = 8;  

          	List<int> RetriableCodes =  
        	    new List<int> { 4060, 40197, 40501, 40613,  
	            49918, 49919, 49920, 11001,208,18456 };  

            for (int retries = 1; retries <= retryCount; retries++)  
            {  
                try  
                {  
                    if (retries > 1)  
                    {  
                        Thread.Sleep(1000 * retryInterval);  
                        retryInterval = Convert.ToInt32 (retryInterval * 1.5);  
                    }  
                    await MyDatabaseOperation();  
                    success = true;  
                    break;  
                }  
                catch (SqlException se)  
                {  
                    if (RetriableCodes.Contains (se.Number) == true)  
                    {  
                        Console.WriteLine("\n[{0}] -- Retriable App Exception!!!" +
                        " -- SQL Error: {1} -- Exception Message: {2} \n\n", 
                        DateTime.Now.ToUniversalTime(), se.Number, se.Message);
                        continue;  
                    }  
                    else  
                    {  
                        Console.WriteLine("\n[{0}] -- Non-retriable App Exception!!!" +
                        " -- SQL Error: {1} -- Exception Message: {2} \n\n", 
                        DateTime.Now.ToUniversalTime(), se.Number, se.Message);
                        success = false;  
                        break;  
                    }  
                }  
                catch (Exception e)  
                {  
                    Console.WriteLine("\n[{0}] -- Non-retriable App "+
                    "Exception!!!  -- Exception Message: {1} \n\n", 
                    DateTime.Now.ToUniversalTime(), e.Message);
                    success = false;  
                    break;  
                }
            }
        }
        static async Task MyDatabaseOperation()
        {
            using (SqlConnection cnn = 
                new SqlConnection(
                "Server=tcp:<servername>.database.windows.net,"+
                "1433;Initial Catalog=WideWorldImporters-Full;"+
                "User ID=<username>;Password=<password>;"+
                "Connect Timeout=10;"))
            {
                SqlCommand cmd = 
                    new SqlCommand("SELECT * FROM sysobjectz",cnn);
                await cnn.OpenAsync();                
                
                await cmd.ExecuteReaderAsync();
            }
        }        
    }
}