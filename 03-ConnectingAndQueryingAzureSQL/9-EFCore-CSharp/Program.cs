using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace efcore
{
    class Program
    {
        static void Main(string[] args)
        {
            using(var dbctx = new WWImportersContext())
            {
                var res = dbctx.Orders
                    .Include("Customer")
                    .Select (o => new {o.OrderID,o.OrderDate,o.Customer.CustomerName})
                    .ToList().Take(10);

                foreach(var o in res)
                {
                    Console.WriteLine("OrderId: {0} - OrderDate: {1} - CustomerName: {2}"
                    ,o.OrderID,o.OrderDate,o.CustomerName);
                }         
            }
        }
    }
    class Order
    {
        public int OrderID {get;set;}
        public DateTime OrderDate {get;set;}
        public int CustomerID {get;set;}
        public Customer Customer {get;set;}
    }
    class Customer
    {
        public int CustomerID {get;set;}
        public String CustomerName {get;set;}
    }
    class WWImportersContext : DbContext
    {
        public static readonly ILoggerFactory MyLoggerFactory
            = LoggerFactory.Create(builder => { 
                    builder
                        .AddFilter((category, level) =>
                            category == DbLoggerCategory.Database.Command.Name
                            && level == LogLevel.Information)
                        .AddConsole();                
                });
        public DbSet<Order> Orders {get;set;}
        public DbSet<Customer> Customers {get;set;}
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .UseLoggerFactory(MyLoggerFactory) // Warning: Do not create a new ILoggerFactory instance each time
                .UseSqlServer(
                @"Server=tcp:<servername>.database.windows.net," +
                "1433;Initial Catalog=WideWorldImporters-Full;" +
                "User ID=<username>;Password=<password>");
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Order>(o => o.ToTable("Orders","Sales"));
            modelBuilder.Entity<Customer>(o => o.ToTable("Customers","Sales"));
        }
    }
}
