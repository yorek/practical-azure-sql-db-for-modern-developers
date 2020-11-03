/*
	Select data from table
	Selects Products and returns average Price grouped by State column.
*/
SELECT
	State,
	Price = AVG(Price)
FROM
	Sales.Products
GROUP BY
	State;