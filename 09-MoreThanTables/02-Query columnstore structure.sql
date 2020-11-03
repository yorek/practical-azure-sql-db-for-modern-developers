/*
	Select data from table
	Selects Products that have some values of State column
	and returns average Price grouped by State column.
*/
SELECT
	State, Price = AVG(Price)
FROM
	Sales.Products
WHERE
	State IN ('Available', 'In Stock')
GROUP BY
	State;