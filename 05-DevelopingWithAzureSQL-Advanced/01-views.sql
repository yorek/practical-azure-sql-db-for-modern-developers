-- Use WideWorldImporters database

/*
	Create View
*/
CREATE OR ALTER VIEW [Sales].[OrderLinesRuninngTotal]
AS
SELECT 
	[OrderID],
	[OrderLineID],
	[Description],
	[Quantity],	
	SUM(Quantity) OVER (
		PARTITION BY [OrderID] 
		ORDER BY [OrderLineID] ROWS BETWEEN 
			UNBOUNDED PRECEDING AND 
			CURRENT ROW
	) AS RunningTotal	
FROM 
	[Sales].[OrderLines]
GO

/*
	Use View
*/
SELECT 
	OrderID,
	[OrderLineID],
	[Description],
	[Quantity],
	[RunningTotal]
FROM 
	[Sales].[OrderLinesRuninngTotal];
GO

/*	
	The body of the query using the view and the view body itself are merged togheter.
	This query and the following one are identical, but the query using the view 
	is much easier to read. Also the view can be reused in other queries
*/
SELECT 
	OrderID,
	[OrderLineID],
	[Description],
	[Quantity],
	[RunningTotal]
FROM 
	[Sales].[OrderLinesRuninngTotal]
WHERE
	[OrderID] IN (41, 42, 43);

SELECT 
	[OrderID],
	[OrderLineID],
	[Description],
	[Quantity],	
	SUM(Quantity) OVER (
		PARTITION BY [OrderID] 
		ORDER BY [OrderLineID] ROWS BETWEEN 
			UNBOUNDED PRECEDING AND 
			CURRENT ROW
	) AS RunningTotal	
FROM 
	[Sales].[OrderLines]
WHERE
	[OrderID] IN (41, 42, 43);