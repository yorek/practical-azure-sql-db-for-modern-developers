-- Use WideWorldImporters database

/*
	Query with three subqueries
*/
SELECT
	OrderId,
	OrderDate,
	(SELECT COUNT(*) FROM Sales.[OrderLines] AS ol WHERE ol.[OrderID] = o.OrderId) AS OrderSize
FROM
	(SELECT * FROM Sales.[Orders] WHERE SalespersonPersonID = 2) AS o
WHERE
	o.[CustomerID] IN 
	(
		SELECT	
			c.CustomerID
		FROM
			Sales.[Customers] AS c
		WHERE
			[CustomerName] = 'Daniel Martensson'
	)
AND
	OrderDate >= '2015-01-01'
ORDER BY
	[o].[OrderID]
;

/*
	Some subqueries can be rewritten as join
*/
SELECT
	o.OrderId,
	o.OrderDate,
	(SELECT COUNT(*) FROM Sales.[OrderLines] AS ol WHERE ol.[OrderID] = o.OrderId) AS OrderSize
FROM
	Sales.[Orders] AS o
INNER JOIN
	Sales.[Customers] AS c ON o.[CustomerID] = c.CustomerID
WHERE
	o.[OrderDate] >= '2015-01-01'
AND
	c.[CustomerName] = 'Daniel Martensson'
AND
	o.[SalespersonPersonID] = 2
GROUP BY
	o.[OrderID], [o].[OrderDate]
ORDER BY
	[o].[OrderID]
;

/*
	Another way to rewrite the query
	TODO: highlight different query plans
*/
SELECT
	o.OrderId,
	o.OrderDate,
	COUNT(*) AS OrderSize
FROM
	Sales.[Orders] AS o
INNER JOIN
	Sales.[Customers] AS c ON o.[CustomerID] = c.CustomerID
INNER JOIN
	Sales.[OrderLines] AS ol ON o.[OrderID] = ol.[OrderID]
WHERE
	o.[OrderDate] >= '2015-01-01'
AND
	c.[CustomerName] = 'Daniel Martensson'
AND
	o.[SalespersonPersonID] = 2
GROUP BY
	o.[OrderID], [o].[OrderDate]
ORDER BY
	[o].[OrderID]
;