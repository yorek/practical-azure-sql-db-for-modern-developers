-- Use WideWorldImporters

SELECT * FROM [Sales].[OrderLines]

-- Calculate Running Total for a specific order
SELECT 
	[OrderLineID],
	[Description],
	[Quantity],	
	SUM(Quantity) OVER (ORDER BY [OrderLineID] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM 
	[Sales].[OrderLines]
WHERE
	[OrderID] = 37

GO

-- Calculate Running Total for different orders
SELECT 
	[OrderID],
	[OrderLineID],
	[Description],
	[Quantity],	
	SUM(Quantity) OVER (
		PARTITION BY [OrderID] 
		ORDER BY [OrderLineID] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS RunningTotal	
FROM 
	[Sales].[OrderLines]
WHERE
	[OrderID] in (37, 39)
GO

-- Calculate how many days passes between each order
-- for a specific customer
SELECT
	[OrderID],
	[OrderDate],
	LAG(OrderDate, 1) OVER (ORDER BY [OrderDate]) AS PrevOrderDate,
	DATEDIFF(
		[DAY], 
		LAG(OrderDate, 1) OVER (ORDER BY [OrderDate]), 
		[OrderDate]
	) AS ElapsedDays
FROM
	[Sales].[Orders]
WHERE 
	[CustomerID] = 832
ORDER BY
	[OrderDate]
;

-- Calculate how many days passes between each order
-- for customers and calculate the moving average acroos the last 10 orders
WITH cte AS (
	SELECT
		[CustomerID],
		[OrderID],
		[OrderDate],
		LAG(OrderDate, 1) OVER (PARTITION BY [CustomerID] ORDER BY [OrderDate]) AS PrevOrderDate
	FROM
		[Sales].[Orders]
), 
cte2 AS (
	SELECT
		*,
		DATEDIFF(
			[DAY], 
			LAG(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY [OrderDate]), 
			[OrderDate]
		) AS ElapsedDays
	FROM 
		[cte]
)
SELECT
	*,
	AVG([cte2].[ElapsedDays]) OVER (ORDER BY [OrderID] ROWS BETWEEN 10 PRECEDING AND CURRENT ROW) AS MovingAvg
FROM
	cte2
WHERE
	[CustomerID] = 832
ORDER BY
	[OrderDate]
;
