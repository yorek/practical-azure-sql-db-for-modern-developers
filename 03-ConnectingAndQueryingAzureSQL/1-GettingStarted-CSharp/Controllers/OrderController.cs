using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;

namespace gettingstarted
{
    [ApiController]
    [Produces("application/json")]
    [Route("[controller]")]
    public class OrderController : ControllerBase
    {
        private readonly ILogger <OrderController> _logger;
        private readonly IConfiguration _config;
        public OrderController(ILogger <OrderController> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;
        }
        [HttpGet]
        public IEnumerable <Order> Get()
        {
            OrderRepository or = new OrderRepository(_config);

            return or.GetOrders().Result;
        }
    }
}