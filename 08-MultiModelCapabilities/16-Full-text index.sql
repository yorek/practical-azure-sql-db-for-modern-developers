/*
	Creating full-text index
*/
IF (0 = (SELECT COUNT(*) FROM sys.fulltext_catalogs WHERE name = 'Main'))
	CREATE FULLTEXT CATALOG [Main] AS DEFAULT;  
GO

CREATE FULLTEXT INDEX
	ON Warehouse.StockItems (SearchDetails, CustomFields, Tags)
	KEY INDEX PK_Warehouse_StockItems
	WITH CHANGE_TRACKING AUTO;
GO

