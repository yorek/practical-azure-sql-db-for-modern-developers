import os
import pyodbc
from decouple import config

server = config('server')
database = config('database')
username = config('username')
password = config('password')
driver= '{ODBC Driver 17 for SQL Server}'
cnxn = pyodbc.connect('DRIVER='+driver+';SERVER='+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password,autocommit=True)

def prepare_database():
    try:
        cursor = cnxn.cursor()
        cursor.execute("""IF (EXISTS (SELECT *  FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_SCHEMA = 'dbo' 
                          AND  TABLE_NAME = 'Orders'))
                          BEGIN
                              DROP TABLE [dbo].[Orders];
                          END

                          IF (EXISTS (SELECT *  FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_SCHEMA = 'dbo' 
                          AND  TABLE_NAME = 'Inventory'))
                          BEGIN
                              DROP TABLE [dbo].[Inventory];
                          END

                          CREATE TABLE [dbo].[Orders] (ID int PRIMARY KEY, ProductID int, OrderDate datetime);
                          CREATE TABLE [dbo].[Inventory] (ProductID int PRIMARY KEY, QuantityInStock int 
                            CONSTRAINT CHK_QuantityInStock CHECK (QuantityInStock>-1));

                          -- Fill up with some sample values
                          INSERT INTO dbo.Orders VALUES (1,1,getdate());
                          INSERT INTO dbo.Inventory VALUES (1,0);
                          """)
    except pyodbc.DatabaseError as err:
        print("Couldn't prepare database tables")

def execute_transaction():
    try:
        cnxn.autocommit = False
        cursor = cnxn.cursor()
        cursor.execute("INSERT INTO Orders VALUES (2,1,getdate());")
        cursor.execute("UPDATE Inventory SET QuantityInStock=QuantityInStock-1 WHERE ProductID=1")
    except pyodbc.DatabaseError as err:
        cnxn.rollback()
        print("Transaction rolled back: " + str(err))
    else:
        cnxn.commit()
        print("Transaction committed!")
    finally:
        cnxn.autocommit = True

prepare_database()
execute_transaction()