/*
	Creating table with columnstore index
	Adding CLUSTERED COLUMNSTORE index on a table creates column-organized structure.
*/
DROP TABLE IF EXISTS dbo.Orders;
GO

CREATE TABLE dbo.Orders (
	OrderID int NOT NULL,
	CustomerID int NOT NULL,
	OrderDate date NOT NULL,
	INDEX cci CLUSTERED COLUMNSTORE
)