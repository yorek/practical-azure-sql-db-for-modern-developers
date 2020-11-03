/*
	Setting security access rules on database objects
*/
DROP USER IF EXISTS [SalesMicroservice];
GO
CREATE USER [SalesMicroservice] WITHOUT LOGIN;
-- Alternative: User with password (works only in Azure SQL Database, or in the Managed Instance with contained database)
-- CREATE USER [SalesMicroservice] WITH PASSWORD = 'AVERy_STR0-NGPAZZw0rd!'
GO

GRANT SELECT, INSERT
	ON OBJECT::Sales.Orders
	TO SalesMicroservice;
GRANT SELECT
	ON OBJECT::Sales.Customers
	TO SalesMicroservice;
GRANT SELECT
	ON OBJECT::Sales.Invoices
	TO SalesMicroservice;
GRANT EXECUTE
	ON SCHEMA::Sales
	TO SalesMicroservice;
GO

/*
	Checking permissions
*/
EXECUTE AS USER = 'SalesMicroservice';  
SELECT * FROM fn_my_permissions('Sales.Customers', 'OBJECT');
REVERT;