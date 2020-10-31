-- Use WideWorldImporters database

/*
	Join between two tables
*/
SELECT 
	il.InvoiceLineID AS LineID,
	i.InvoiceID,
	il.[Description],
	il.Quantity,
	il.UnitPrice,
	il.UnitPrice * il.Quantity AS TotalPrice,
	i.ConfirmedDeliveryTime
FROM
	Sales.Invoices AS i
INNER JOIN
	Sales.InvoiceLines AS il ON	i.InvoiceID = il.InvoiceID
WHERE
	i.CustomerID = 998
AND
	il.[Description] LIKE N'%red shirt%'
AND
	CAST(i.ConfirmedDeliveryTime AS DATE) BETWEEN '2016-01-01' and '2016-03-31'
;

/*
	Cascading joins
*/
SELECT 
	c.CustomerName,
	il.InvoiceLineID AS LineID,
	i.InvoiceID,
	il.[Description],
	il.Quantity,
	il.UnitPrice,
	il.UnitPrice * il.Quantity AS TotalPrice,
	i.ConfirmedDeliveryTime
FROM
	Sales.Customers AS c
INNER JOIN
	Sales.Invoices AS i ON i.CustomerID = c.CustomerID
INNER JOIN
	Sales.InvoiceLines AS il ON i.InvoiceID = il.InvoiceID
WHERE
	i.CustomerID = 998
AND
	il.[Description] LIKE N'%red shirt%'
AND
	CAST(i.ConfirmedDeliveryTime AS DATE) BETWEEN '2016-01-01' AND '2016-03-31'
;