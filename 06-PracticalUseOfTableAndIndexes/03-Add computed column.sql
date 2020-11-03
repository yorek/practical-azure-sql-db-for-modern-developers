/*
	Add a computed column as a named expression (drop existing if it already exists)
*/
ALTER TABLE Sales.[OrderLines]
	DROP COLUMN IF EXISTS Profit;
GO

ALTER TABLE Sales.OrderLines
	ADD Profit AS (Quantity*UnitPrice)*(1-TaxRate);
GO

/*
	Add a computed column as persisted automatically re-calculated column  (drop existing if it already exists)
*/
ALTER TABLE Sales.[OrderLines]
	DROP COLUMN IF EXISTS Profit;
GO
ALTER TABLE Sales.OrderLines
	ADD Profit AS (Quantity*UnitPrice)*(1-TaxRate) PERSISTED;
GO