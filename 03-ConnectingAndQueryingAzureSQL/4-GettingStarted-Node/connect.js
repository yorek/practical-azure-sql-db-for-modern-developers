exports.getorders = function(callback) {

  const { Connection, Request } = require("tedious");

  const config = {
    server: "<servername>.database.windows.net",
    options: {
      port: 1433,
      database: "WideWorldImporters-Full",
      encrypt: true,
      trustServerCertificate: false,
      validateBulkLoadParameters: true},
    authentication: {
      type: "default",
      options: {
        userName: "<username>",
        password: "<password>",
      }
    }
  };
    
  const connection = new Connection(config);
  connection.connect()

  connection.on("connect", err => {
    if (err) {
      console.error(err);
    } else {
      getOrders(function(res) {        
        return callback(res);
      });
    }
  });
    
  function getOrders(callback) {
    var data = []
    const request = new Request(
      `SELECT TOP 5 [o].[OrderID],
      [o].[OrderDate], [c].[CustomerName]
      FROM [Sales].[Orders] AS [o]
      INNER JOIN [Sales].[Customers] AS [c]
      ON [o].[CustomerID] = [c].[CustomerID]`,
      (err, rowCount) => {
        if (err) {
          console.error(err.message);
        }
        else {
          //console.log(`${rowCount} row(s) returned`);
          //res.send({ status: 200, data: data, message: "OK"})
          //console.log (data);
          return callback(data);
        }
      }
    );
    request.on("row", function(row) {
       data.push({
         orderid: row[0].value,
         orderdate: row[1].value,
         customername: row[2].value
       })    
    });
    connection.execSql(request); 
  }
};