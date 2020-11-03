/*
	Searching JSON text using full-text search
*/

SELECT
	si.StockItemID,
	si.StockItemName,
	si.Tags
FROM
	Warehouse.StockItems AS si
WHERE
	CONTAINS(CustomFields,
				 'NEAR((CountryOfManufacture,USA),1)');
GO

SELECT
	*
FROM
	Warehouse.StockItems
WHERE
	CONTAINS(CustomFields, 'NEAR((CountryOfManufacture,USA),1)')
AND
	JSON_VALUE(CustomFields,'$.CountryOfManufacture') = 'USA';
