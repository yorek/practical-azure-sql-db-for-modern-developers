using System;
using Microsoft.Data.SqlClient;
using Dapper;

namespace dappercsharp
{
    class Program
    {
        static void Main(string[] args)
        {
            using (SqlConnection cnn = 
                new SqlConnection(
                "Server=tcp:<servername>.database.windows.net,"+
                "1433;Initial Catalog=WideWorldImporters-Full;"+
                "User ID=<username>;Password=<password>;"))
            {
                var orders = cnn.Query<Order>("SELECT TOP 10 OrderID, OrderDate, CustomerID FROM Sales.Orders;");
                foreach (var o in orders)
                {
                    Console.WriteLine("OrderId: {0} - OrderDate: {1} - CustomerId: {2}",o.OrderID,o.OrderDate,o.CustomerID);

                }
            }
        }
    }
    class Order
    {
        public int OrderID {get;set;}
        public DateTime OrderDate {get;set;}
        public int CustomerID {get;set;}
    }
}
