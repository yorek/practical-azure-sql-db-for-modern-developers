using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

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

#if OLDWAY
        /// <summary>
        ///     get ALL the data from Db then return at once
        /// </summary>
        /// <remarks>
        ///     long wait before any response, and likely memory-hog
        /// </remarks>
        /// <returns>
        ///     IEnumerable<Order>
        /// </returns>
        /// <see cref="https://anthonychu.ca/post/async-streams-dotnet-core-3-iasyncenumerable/"/>

        [HttpGet]
        public IEnumerable <Order> Get()
        {
            OrderRepository or = new OrderRepository(_config);

            return or.GetOrders().Result;
        }

#else
        /// <summary>
        ///     stream data rather than batch-up the entire entity
        /// </summary>
        /// <remarks>
        ///     NET Core 3 and C# 8.0 adds IAsyncEnumerable<T> (aka async streams) incl ASP.NET
        /// </remarks>
        /// <returns>
        ///     IAsyncEnumerable<Order>
        /// </returns>
        /// <see cref="https://anthonychu.ca/post/async-streams-dotnet-core-3-iasyncenumerable/"/>
        /// <seealso cref="https://dotnetcoretutorials.com/2019/01/09/iasyncenumerable-in-c-8/"/>
        [HttpGet]
        public IAsyncEnumerable <Order> GetOrders()
        {
            OrderRepository or = new OrderRepository(_config);
            return or.GetOrdersAsync();
        }
#endif
    }
}