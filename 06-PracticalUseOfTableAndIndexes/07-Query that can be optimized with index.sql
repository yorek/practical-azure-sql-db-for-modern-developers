/*
	Query that can be optimized with index
*/

-- Create a schema to hold test tables
IF (0 = (SELECT COUNT(*) FROM sys.schemas WHERE name = 'test'))
	EXEC sp_executesql N'CREATE SCHEMA [test]'
GO

DROP TABLE IF EXISTS test.Customers;
DROP TABLE IF EXISTS test.Orders;

-- Create some tables from existing ones, but without any index
SELECT * INTO test.Customers FROM Sales.Customers
SELECT * INTO test.Orders FROM Sales.Orders
GO

-- Return elapsed time and IO count (in the "Messages" tab)
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

-- Run a sample query
SELECT
	c.CustomerName,
	c.CreditLimit, 
	o.CustomerPurchaseOrderNumber,
	o.DeliveryInstructions
FROM
	test.Customers AS c 
	INNER JOIN test.Orders AS o
		ON c.CustomerID = o.CustomerID
WHERE
	c.PostalCityID = 37886;
GO

/*
You will see something like

SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 125 ms, elapsed time = 141 ms.

(72 rows affected)
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 818, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 38, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 16 ms,  elapsed time = 21 ms.

Completion time: 2020-09-19T13:10:48.5823372-07:00
*/