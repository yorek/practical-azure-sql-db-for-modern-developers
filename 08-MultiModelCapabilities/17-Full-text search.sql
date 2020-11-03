/*
	Searching indexed items using full-text search
*/
DECLARE @SearchCondition NVARCHAR(200) = 'blue car';

SELECT
	StockItemID = ft.[KEY],
	ft.[RANK]
FROM
	FREETEXTTABLE(Warehouse.StockItems, SearchDetails, @SearchCondition) AS ft
GO

DECLARE @SearchCondition NVARCHAR(200) = 'blue AND car';

SELECT 
	si.StockItemID, 
	si.StockItemName, 
	ft.[RANK]
FROM 
	Warehouse.StockItems AS si
	INNER JOIN 
		CONTAINSTABLE(Warehouse.StockItems, SearchDetails, @SearchCondition) AS ft
			ON si.StockItemID = ft.[KEY]
ORDER BY 
	ft.[RANK];
GO

DECLARE @SearchCondition NVARCHAR(200) = 'FORMSOF(INFLECTIONAL,children) OR car';

SELECT 
	si.StockItemID, 
	si.StockItemName, 
	si.SearchDetails
FROM 
	Warehouse.StockItems AS si
WHERE 
	CONTAINS(SearchDetails, @SearchCondition);
GO