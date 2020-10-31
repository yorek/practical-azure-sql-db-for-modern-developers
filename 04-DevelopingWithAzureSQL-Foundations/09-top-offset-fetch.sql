-- Use WideWorldImporters

-- The Sales.Orders table has a lot of rows
SELECT FORMAT(COUNT(*), '0,#') AS [RowCount] FROM [Sales].[Orders];

-- Return only the first 100 rows
SELECT TOP (100) * FROM [Sales].[Orders];

-- Return only the first 100 rows ordered by ExpectedDeliveryDate
SELECT TOP (100) 
	* 
FROM 
	[Sales].[Orders] 
ORDER BY 
	[ExpectedDeliveryDate] DESC;

-- Return only 50 rows ordered by ExpectedDeliveryDate,
-- Skipping the first 50 rows
SELECT 
	* 
FROM 
	[Sales].[Orders] 
ORDER BY 
	[ExpectedDeliveryDate] DESC
OFFSET 
	50 ROWS 
FETCH 
	NEXT 50 ROWS ONLY
;
	
