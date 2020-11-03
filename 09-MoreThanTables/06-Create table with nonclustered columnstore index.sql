/*
	Creating NONCLUSTERED COLUMNSTORE index
	Adding NONCLUSTERED COLUMNSTORE index on a table additional copy of cells in column-organized structure.
*/
DROP TABLE IF EXISTS dbo.Sales;
GO

CREATE TABLE dbo.Sales (
	SalesID int,
	Price float,
	Description nvarchar(4000),
	State varchar(20),
	Quantity int,
	INDEX ncci NONCLUSTERED COLUMNSTORE (Price, Quantity, SalesID)
);