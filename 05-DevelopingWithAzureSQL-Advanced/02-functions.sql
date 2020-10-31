-- Use WideWorldImporters database

/*
	Create Inline Table-Valued Function
*/
CREATE OR ALTER FUNCTION dbo.GetOrderTotals(@FromOrderId AS INT, @ToOrderID AS INT)
RETURNS TABLE
AS 
RETURN 
WITH cte AS (
	SELECT
		[OrderId],	
		SUM([Quantity]) AS TotalQuantity,
		SUM([Quantity] * [UnitPrice]) AS TotalValue
	FROM 
		[Sales].[OrderLines]
	WHERE
		[OrderId] BETWEEN @FromOrderId AND @ToOrderID    
	GROUP BY
		[OrderId]
)
SELECT
	o.[OrderId],	
	o.[OrderDate],
	ol.[TotalQuantity],
	ol.[TotalValue]
FROM 
	cte ol 
INNER JOIN
	[Sales].[Orders] o ON [ol].[OrderID] = [o].[OrderID]
GO

/*
	Use created Function
*/
SELECT 
	[OrderID],
	[OrderDate],
	[TotalQuantity],
	[TotalValue] 
FROM 
	dbo.[GetOrderTotals](40, 42);
go

/*
	Multi-Statement Table-Valued Function
*/
CREATE OR ALTER FUNCTION dbo.AlternativeGetOrderTotals(@FromOrderId AS INT, @ToOrderID AS INT)
RETURNS @result TABLE
(
    OrderId INT PRIMARY KEY NOT NULL,
    OrderDate DATE NOT NULL,
    TotalQuantity INT NOT NULL,
    TotalValue DECIMAL(13,2) NOT NULL    
)
AS 
BEGIN

	DECLARE @temp TABLE
	(
		OrderId INT PRIMARY KEY NOT NULL,
		TotalQuantity INT NOT NULL,
		TotalValue DECIMAL(13,2) NOT NULL    
	);

	INSERT INTO 
		@temp
	SELECT
		[OrderId],	
		SUM([Quantity]) AS TotalQuantity,
		SUM([Quantity] * [UnitPrice]) AS TotalValue
	FROM 
		[Sales].[OrderLines]
	WHERE
		[OrderId] BETWEEN @FromOrderId AND @ToOrderID    
	GROUP BY
		[OrderId];

	INSERT INTO 
		@result
	SELECT
		o.[OrderId],	
		o.[OrderDate],
		ol.[TotalQuantity],
		ol.[TotalValue]
	FROM 
		@temp AS ol 
	INNER JOIN
		[Sales].[Orders] o ON [ol].[OrderID] = [o].[OrderID]

	RETURN
END
GO

/*
	Use created Function
*/
SELECT 
	[OrderID],
	[OrderDate],
	[TotalQuantity],
	[TotalValue] 
FROM 
	dbo.[AlternativeGetOrderTotals](40, 42);
go

/*
	Scalar Function
*/
CREATE OR ALTER FUNCTION dbo.GenerateInvoiceNumber(@CustomerID INT, @InvoiceID INT) 
RETURNS VARCHAR(50)
AS
BEGIN    
    DECLARE @InvoiceNumber VARCHAR(50);
    SET @InvoiceNumber = 'INV' + CAST(@CustomerID * 1000000 + @InvoiceID AS VARCHAR(16))
    RETURN @InvoiceNumber;
END

/*
	Use created Function
*/
SELECT TOP(10)
    dbo.GenerateInvoiceNumber(CustomerId, InvoiceID) as InvoiceNumber,
    *
FROM 
	Sales.Invoices
go