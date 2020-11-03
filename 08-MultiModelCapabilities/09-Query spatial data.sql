/*
	Spatial query: All flightlines crossing Nebraska
*/
DECLARE @nebraska GEOGRAPHY = (
	SELECT TOP (1) Border
	FROM Application.StateProvinces
	WHERE StateProvinceName = 'Nebraska'
);

SELECT
	*
FROM
	FlightLine
WHERE
	Route.STIntersects(@nebraska) = 1;
GO

/*
	Spatial query: Airports closest to the given location
*/
DECLARE @currentLocation GEOGRAPHY = 'POINT(-121.626 47.8315)';  

SELECT TOP(5)
	*
FROM
	Airport 
ORDER BY
	Location.STDistance(@currentLocation) ASC;
