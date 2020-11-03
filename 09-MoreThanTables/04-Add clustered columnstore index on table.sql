/*
	Converting a table to columnstore format
	Adding CLUSTERED COLUMNSTORE index on an existing table creates column-organized structure.
*/
DROP TABLE IF EXISTS dbo.Orders;
GO

CREATE TABLE dbo.Orders (
	OrderID int NOT NULL,
	CustomerID int NOT NULL,
	OrderDate date NOT NULL
);
GO

CREATE CLUSTERED COLUMNSTORE INDEX cci ON dbo.Orders;