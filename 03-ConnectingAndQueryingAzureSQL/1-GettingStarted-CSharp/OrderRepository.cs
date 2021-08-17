using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace gettingstarted
{
    public class OrderRepository
    {
        private readonly IConfiguration _config;

        public OrderRepository(IConfiguration config) =>
            _config = config;
        public async Task<IEnumerable<Order>> GetOrders()
        {
            List<Order> orders = new List<Order>();
            using (SqlConnection cnn =
                    new SqlConnection(_config.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand
                (@"SELECT TOP 5         -- always specify order (no generic 'pint of lager' accepted in my pub)
                        [o].[OrderID], [o].[OrderDate], [c].[CustomerName]
                        FROM [Sales].[Orders] AS [o]
                        INNER JOIN [Sales].[Customers] AS [c] 
                        ON [o].[CustomerID] = [c].[CustomerID]
                        ORDER BY o.OrderDate desc, c.CustomerName",
                 cnn);
                await cnn.OpenAsync();
                SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (await dr.ReadAsync())
                {
                 orders.Add(new Order()
                    {
                        OrderID = Convert.ToInt32(dr[0]),
                        OrderDate = Convert.ToDateTime(dr[1]),
                        CustomerName = Convert.ToString(dr[2])
                       });
                }
            }
            return orders;
        }

        public async IAsyncEnumerable<Order> GetOrdersAsync()
        {
            using (SqlConnection cnn =
                    new SqlConnection(_config.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand
                (@"SELECT TOP 5         -- always specify order (no generic 'pint of lager' accepted in my pub)
                        [o].[OrderID], [o].[OrderDate], [c].[CustomerName]
                        FROM [Sales].[Orders] AS [o]
                        INNER JOIN [Sales].[Customers] AS [c] 
                        ON [o].[CustomerID] = [c].[CustomerID]
                        ORDER BY o.OrderDate desc, c.CustomerName",
                 cnn);
                await cnn.OpenAsync();
                SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (await dr.ReadAsync())
                {
                    yield return new Order
                    {
                        OrderID = Convert.ToInt32(dr[0]),
                        OrderDate = Convert.ToDateTime(dr[1]),
                        CustomerName = Convert.ToString(dr[2])
                    };
                }
            }
        }
    }
}