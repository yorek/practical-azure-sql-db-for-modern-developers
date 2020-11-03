var express = require("express");
var app = express();

var db = require('./connect');

app.get("/customer", (req, res, next) => {
      db.getorders(function(response) {
        res.send(response);  
      });
   });

app.listen(9999, () => {
 console.log("Server running on port 9999");
});
