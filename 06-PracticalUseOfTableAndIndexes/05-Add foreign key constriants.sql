/*
	Adding foreign key constraints (dropping existing if they exist)
*/
ALTER TABLE Sales.Invoices
	DROP CONSTRAINT IF EXISTS FK_Cust_Inv
ALTER TABLE Sales.Orders
	DROP CONSTRAINT IF EXISTS FK_Cust_Orders
GO
ALTER TABLE Sales.Invoices
	ADD CONSTRAINT FK_Cust_Inv FOREIGN KEY (CustomerID)
		REFERENCES Sales.Customers (CustomerID) ON DELETE CASCADE;
GO
ALTER TABLE Sales.Orders
	ADD CONSTRAINT FK_Cust_Orders FOREIGN KEY (CustomerID)
		REFERENCES Sales.Customers (CustomerID) ON DELETE NO ACTION;
