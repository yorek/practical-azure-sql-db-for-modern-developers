-- Use WideWorldImporters

-- Base GROUP BY Query
SELECT 
	[SupplierID], 
	[ColorID],
	COUNT(*) AS ProductsInStock,
	SUM(QuantityPerOuter) AS ProductsQuantity
FROM 
	[Warehouse].[StockItems]
GROUP BY
	[SupplierID], [ColorID]
ORDER BY
	[SupplierID], [ColorID];
GO

-- JOIN the StockItems table with Suppliers and Colors 
-- to get Suppliers Colors name.
-- This means that Azure SQL will first procceed to join the tables
-- and then will execute the aggregation.
SELECT 
	si.[SupplierID], 
	s.[SupplierName],
	si.[ColorID],
	c.[ColorName],
	COUNT(*) AS ProductsInStock,
	SUM(QuantityPerOuter) AS ProductsQuantity
FROM 
	[Warehouse].[StockItems] AS si
INNER JOIN
	[Purchasing].[Suppliers] s ON si.[SupplierID] = s.[SupplierID]
LEFT OUTER JOIN
	[Warehouse].[Colors] c ON si.[ColorID] = c.[ColorID]
GROUP BY
	si.[SupplierID], si.[ColorID], c.[ColorName], s.[SupplierName]
ORDER BY
	si.[SupplierID], si.[ColorID]
GO

-- Using a subquery (this time via a CTE)
-- In this case we also help Azure SQL do a better job 
-- As we indicate that data can be joined after being
-- aggregated, hereby reducing the amout of rows
-- that will be used for the JOIN
WITH cte AS (
	SELECT 
		si.[SupplierID], 
		si.[ColorID],
		COUNT(*) AS ProductsInStock,
		SUM(QuantityPerOuter) AS ProductsQuantity
	FROM 
		[Warehouse].[StockItems] AS si
	GROUP BY
		si.[SupplierID], si.[ColorID]
)
SELECT
	s.[SupplierID],
	s.[SupplierName],
	c.[ColorID],
	c.[ColorName],
	g.[ProductsInStock],
	g.[ProductsQuantity]
FROM
	[cte] AS g
INNER JOIN
	[Purchasing].[Suppliers] s ON g.[SupplierID] = s.[SupplierID]
LEFT OUTER JOIN
	[Warehouse].[Colors] c ON g.[ColorID] = c.[ColorID]
ORDER BY
	g.[SupplierID], g.[ColorID]
GO



