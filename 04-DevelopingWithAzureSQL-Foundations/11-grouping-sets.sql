-- Use WideWorldImporters

-- Use GROUP BY with GROUPING SETS
-- Aggregating values by
--   SupplierID & ColorID
--   SupplierID
--   ColorID
-- and calculate overall total in just one pass.
-- Also use GROUPING funcion to discriminate NULL 
-- values between two meanings: when it means color
-- is unknown or not applicable and when the line
-- represent an aggregation of all colors
SELECT 
	[SupplierID], 
	[ColorID],
	COUNT(*) AS ProductsInStock,
	SUM(QuantityPerOuter) AS ProductsQuantity,
	GROUPING(ColorID) as IsAllColors,
	GROUPING(SupplierID) as IsAllSuppliers	
FROM 
	[Warehouse].[StockItems]
GROUP BY
	GROUPING SETS
	(
		([SupplierID], [ColorID]),
		([SupplierID]),
		([ColorID]),
		()
	)
ORDER BY
	IsAllColors, IsAllSuppliers
;