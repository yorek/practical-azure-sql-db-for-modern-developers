/*
	Query graph data
*/
SELECT 
	src.Name, fl.Name, dest.Name
FROM 
	Airport src, Flightline fl, Airport dest
WHERE
	MATCH(src-(fl)->dest)
AND
	src.Name='BEG';

WITH routes AS (
	SELECT 
		src.Name,
		STRING_AGG(dest.name, '->')
			WITHIN GROUP (GRAPH PATH) AS path,
		COUNT(dest.name)
			WITHIN GROUP (GRAPH PATH) AS stops,
		LAST_VALUE(fl.name)
			WITHIN GROUP (GRAPH PATH) AS lastFlight,
		LAST_VALUE(dest.name)
			WITHIN GROUP (GRAPH PATH) AS destination
	FROM 
		Airport src, 
		Flightline FOR PATH fl,
		Airport FOR PATH dest
	WHERE
		MATCH(SHORTEST_PATH(src(-(fl)->dest)+))
	AND
		src.Name='BEG'
)
SELECT
	path, stops, lastFlight, destination
FROM
	routes
WHERE
	destination = 'SEA';