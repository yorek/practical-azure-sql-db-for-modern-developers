using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace appinsight
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly WWImportersContext _context;

        private readonly ILogger<CustomerController> _logger;

        public CustomerController(ILogger<CustomerController> logger,WWImportersContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public IEnumerable<Customer> Get()
        {
                return _context.Customers.Take(10).ToList();
        }
    }
}
