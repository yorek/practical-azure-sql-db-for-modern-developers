import pyodbc
import logging
import urllib
from sqlalchemy import *

server = 'tcp:<servername>.database.windows.net,1433'
database = 'WideWorldImporters-Full'
username = '<username>'
password = '<password>'

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.WARN)

def my_database_operation():

    global server
    global realserver
    global database
    global username
    global password

    cnnString = urllib.parse.quote_plus('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password+';Connect Timeout=10;')
 
    engine = create_engine("mssql+pyodbc:///?odbc_connect=%s" % cnnString)

    metadata = MetaData()

    orders = Table('Orders', metadata,
        Column('orderid', Integer, primary_key=True),
        Column('customerid', Integer),
        Column('orderdate', Date),
        schema='Sales'
    )

    customers = Table('Customers', metadata,
        Column('customerid',Integer,primary_key=True),
        Column('customername',String),
        schema='Sales'
    )

    s = select([orders.c.orderid,orders.c.orderdate,customers.c.customername]).\
            select_from(orders.join(customers, orders.c.customerid==customers.c.customerid)).\
                limit(10)

    try:
        cnn = engine.connect()
        res = cnn.execute(s)

        for row in res:
            print(row)

        cnn.close()
    except Exception as e:
        print (e)
        pass

my_database_operation()