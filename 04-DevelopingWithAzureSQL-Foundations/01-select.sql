-- Use WideWorldImporters database

/*
	Simple Select
*/
SELECT 
	InvoiceID,
	InvoiceDate,
	DeliveryInstructions,
	ConfirmedDeliveryTime
FROM
	Sales.Invoices
WHERE
	CustomerID = 998
ORDER BY
	ConfirmedDeliveryTime 
;