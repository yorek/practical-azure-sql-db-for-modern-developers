/*
	Change the column collation
*/
ALTER TABLE Warehouse.StockItems
	ALTER COLUMN Brand NVARCHAR(50) COLLATE Serbian_Cyrillic_100_CI_AI

