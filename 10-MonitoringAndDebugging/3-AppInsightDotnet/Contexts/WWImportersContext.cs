using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace appinsight
{
    public class WWImportersContext : DbContext
    {
        public static readonly ILoggerFactory MyLoggerFactory
            = LoggerFactory.Create(builder => { 
                    builder
                        .AddFilter((category, level) =>
                            category == DbLoggerCategory.Database.Command.Name
                            && level == LogLevel.Information)
                        .AddConsole();                
                });

        public DbSet<Customer> Customers {get;set;}
        public WWImportersContext (DbContextOptions options) : base(options)
        {}
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .UseLoggerFactory(MyLoggerFactory);
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Customer>(o => o.ToTable("Customers","Sales"));
        }
    }
}