/*
	Searching text values
*/
DECLARE @searchText NVARCHAR(20) = 'Gray';

SELECT
	si.StockItemID,
	si.StockItemName,
	si.Tags
FROM
	Warehouse.StockItems AS si
WHERE
	si.SearchDetails LIKE N'%' + @SearchText + N'%'
	OR si.Tags LIKE N'%' + @SearchText + N'%';
