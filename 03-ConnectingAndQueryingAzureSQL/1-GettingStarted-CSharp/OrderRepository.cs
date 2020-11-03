using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace gettingstarted
{
    public class OrderRepository
    {
        private readonly IConfiguration _config;

        public OrderRepository(IConfiguration config)
        {
            _config = config;
        }
        public async Task<IEnumerable<Order>> GetOrders()
        {
            List<Order> orders = new List<Order>();
            using (SqlConnection cnn = 
                    new SqlConnection(_config.GetConnectionString("DefaultConnection")))
            {               
                SqlCommand cmd = new SqlCommand
                (@"SELECT TOP 5 
                        [o].[OrderID], [o].[OrderDate], [c].[CustomerName]
                        FROM [Sales].[Orders] AS [o]
                        INNER JOIN [Sales].[Customers] AS [c] 
                        ON [o].[CustomerID] = [c].[CustomerID]",cnn);
                await cnn.OpenAsync();                                
                SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (dr.Read())
                {                
                    orders.Add(new Order() {OrderID = Convert.ToInt32(dr[0]),
                                            OrderDate = Convert.ToDateTime(dr[1]), 
                                            CustomerName = Convert.ToString(dr[2])});
                }
            }
            return orders;
        }
    }
}