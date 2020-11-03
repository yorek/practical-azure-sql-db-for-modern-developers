/*
	Creating indexes that optimize a query
*/

CREATE INDEX ix_Customer_PostalCityID
	ON test.Customers(PostalCityID);
GO

CREATE INDEX ix_Orders_CustomerID
	ON test.Orders(CustomerID);
GO

-- Re-Run the query now
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

SELECT
c.[PostalCityID],
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
   CPU time = 0 ms, elapsed time = 5 ms.

(72 rows affected)
Table 'Orders'. Scan count 1, logical reads 74, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 3, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2020-09-19T13:11:52.2126504-07:00

From 818 logical reads to 74 for the Orders table.
From 38 logical reads to 3 for the Customers table.
CPU time from 16ms to less than 1ms.
*/

-- Clean up
DROP TABLE test.[Customers];
DROP TABLE test.[Orders];
GO

DROP SCHEMA [test]
GO