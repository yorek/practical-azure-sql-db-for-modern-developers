-- Use WideWorldImporters database

/*
	Union Sample
*/
WITH cteContacts AS
(
	SELECT [CustomerID], [PrimaryContactPersonID] AS ContactPersonId, 'Primary' AS [ContactType] FROM Sales.[Customers] 
	UNION 
	SELECT [CustomerID], [AlternateContactPersonID], 'Alternate' AS [ContactType] FROM Sales.[Customers] 
)
SELECT
	[ContactPersonId],
	[ContactType]
FROM
	[cteContacts] c
WHERE
	c.CustomerId = 42