-- Use WideWorldImporters database

/*
	Create Stored Procedure
*/
CREATE OR ALTER PROCEDURE dbo.GetOrderForCustomer
@CustomerInfo NVARCHAR(MAX)
AS
IF (ISJSON(@CustomerInfo) != 1) BEGIN
	THROW 50000, '@CustomerInfo is not a valid JSON document', 16
END

SELECT [Value] INTO #T FROM OPENJSON(@CustomerInfo, '$.CustomerId') AS ci;

SELECT 
	[CustomerID], 
	COUNT(*) AS OrderCount,  
	MIN([OrderDate]) AS FirstOrder,
	MAX([OrderDate]) AS LastOrder
FROM 
	Sales.[Orders]
WHERE 
	[CustomerID] IN (SELECT [Value] FROM #T)
GROUP BY 
	[CustomerID];
GO

/*
	Use created Stored Procedure
*/
EXEC dbo.GetOrderForCustomer N'{"CustomerId": [106, 193, 832]}';
