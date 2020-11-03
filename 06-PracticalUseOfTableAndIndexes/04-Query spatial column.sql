/*
	Query a table with spatial column
*/
DECLARE @g geography = 'POINT(-95 45.5)';

SELECT TOP(5) 
	[Location].ToString(),
	CityName
FROM
	[Application].Cities
ORDER BY
	[Location].STDistance(@g) ASC;
GO

/*
Complete sample on Geospatial Data can also be found here:

https://github.com/yorek/azure-sql-db-samples/tree/master/samples/05-spatial
*/