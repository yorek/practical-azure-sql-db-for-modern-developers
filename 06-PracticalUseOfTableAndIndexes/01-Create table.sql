/*
	Create a table
	Create a plain table without some advanced indexes or constraints (drop existing table if already exists). 
*/
DROP TABLE IF EXISTS dbo.Customer;
GO
CREATE TABLE dbo.Customer (
	CustomerID tinyint,
	CustomerName varchar(max),
	LocationID bigint
);