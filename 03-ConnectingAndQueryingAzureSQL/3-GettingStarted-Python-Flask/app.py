import sys
import os
from flask import Flask
import json
import pyodbc
import collections

from flask import Flask
app = Flask(__name__)

conn = pyodbc.connect(os.environ['CONNSTR'])

@app.route('/')
def hello():
    return "Hello World!"

@app.route('/order')
def getorders():
    
    cursor = conn.cursor()

    tsql = "SELECT TOP 5 " \
                " [o].[OrderID], [o].[OrderDate]," \
                " [c].[CustomerName]" \
                " FROM [Sales].[Orders] AS [o]" \
                " INNER JOIN [Sales].[Customers] AS [c]" \
                " ON [o].[CustomerID] = [c].[CustomerID]"

    rows = cursor.execute(tsql).fetchall()
        
    order_list = []
    for row in rows:
            d = collections.OrderedDict()
            d['orderID'] = row.OrderID
            d['orderDate'] = str(row.OrderDate)
            d['customerName'] = row.CustomerName
            order_list.append(d)
        
    return json.dumps(order_list)

if __name__ == '__main__':
    app.run()
