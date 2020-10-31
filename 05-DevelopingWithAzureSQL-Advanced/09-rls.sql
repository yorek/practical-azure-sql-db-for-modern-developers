-- Use WideWorldImporters database

/*
	Create a schema to be used in this example
*/
IF (SCHEMA_ID('rls') IS NULL) BEGIN
	EXEC('CREATE SCHEMA [rls]');
END
GO

/*
	Create the Inline Table-Valued Function to be used
	for enforcing the Security Policy
*/
DROP FUNCTION IF EXISTS rls.LogonSecurityPolicy;
GO
CREATE FUNCTION rls.LogonSecurityPolicy(@PersonID AS INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
SELECT 
	1 As [Authorized]
FROM 
	[Application].[People] 
WHERE 
	LogonName = SESSION_CONTEXT(N'Logon')
AND
	PersonID = @PersonId
GO

/*
	Create the Security Policy
*/
CREATE SECURITY POLICY OrderSecurityPolicy
ADD FILTER PREDICATE [rls].LogonSecurityPolicy(SalespersonPersonID) ON [Sales].[Orders],
ADD BLOCK PREDICATE [rls].LogonSecurityPolicy(SalespersonPersonID) ON [Sales].[Orders]
WITH (STATE = ON);  

/*
	Set a Session Context, simulating that Kayla (ID=2) logged in
	By setting @readOnly to False it will be possibile to simulate different Logon values
	without having to disconnect and reconnect
*/
EXEC sp_set_session_context @key=N'Logon', @value=N'kaylaw@wideworldimporters.com', @readOnly=0
GO

/*
	Kyala can only see her own orders (due to FILTER predicate)
*/
SELECT * FROM [Sales].[Orders]
GO

/*
	Kyala can insert/update/delete rows she has access to (due to FILTER predicate)
*/
UPDATE [Sales].[Orders] SET Comments = 'Happy customer!' WHERE [OrderID] = 1;

/*
	Kyala CANNOT insert/update/delete rows she doesn't have access to (due to FILTER predicate)
*/
UPDATE [Sales].[Orders] SET Comments = 'Happy customer!' WHERE [OrderID] = 38;

/*
	Kyala CANNOT change an order so that it will be moved out of her scope (due to BLOCK predicate)
*/
UPDATE [Sales].[Orders] SET [SalespersonPersonID] = 16 WHERE [OrderID] = 1 ;

/*
	Simulate another user logged in
*/
EXEC sp_set_session_context @key=N'Logon', @value=N'archerl@wideworldimporters.com', @readOnly=0
GO

/*
	Archer can only see her own orders (due to FILTER predicate)
*/
SELECT * FROM [Sales].[Orders]
GO

/*
	Simulate guest login
*/
EXEC sp_set_session_context @key=N'Logon', @value=N'someone@email.com', @readOnly=0
GO

/*
	No orders returned, as external users are NOT authorized to see placed orders (due to FILTER predicate)
*/
SELECT * FROM [Sales].[Orders]
GO

/*
	Disable Security Policy
*/
ALTER SECURITY POLICY OrderSecurityPolicy
WITH (STATE = OFF);  
GO

/*
	Table is now accessible to everyone
*/
SELECT * FROM [Sales].[Orders]
GO

/*
	Remove Security Policy
*/
DROP SECURITY POLICY OrderSecurityPolicy
GO

/*
	More detailed sample available here:
	
	Creating API to securely access data using Azure SQL Row Level Security
	https://github.com/Azure-Samples/azure-sql-db-secure-data-access-api
*/
