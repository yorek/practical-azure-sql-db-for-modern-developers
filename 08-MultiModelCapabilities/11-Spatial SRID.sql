/*
	Spatial shapes are described using SRID
*/

DECLARE @g GEOGRAPHY;  

SET @g = GEOGRAPHY::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326);  

SELECT @g.STSrid;
