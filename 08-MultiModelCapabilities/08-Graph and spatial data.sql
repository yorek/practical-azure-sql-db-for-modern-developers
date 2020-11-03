/*
	Tables with spatial columns
*/
DROP TABLE IF EXISTS FlightLine;
GO
DROP TABLE IF EXISTS Airport;
GO

CREATE TABLE Airport (
    AirportID int PRIMARY KEY,
    Name NVARCHAR(100),
    Location GEOGRAPHY,
    CityID int FOREIGN KEY REFERENCES Application.Cities(CityID)
) AS NODE
GO

CREATE TABLE FlightLine (
    FlightLineID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(10),
    Route GEOGRAPHY
) AS EDGE;

DELETE Airport
DELETE FlightLine

INSERT INTO
	Airport (AirportID, Name)
VALUES  (1, 'BEG'),
        (2, 'FRA'),
        (3, 'JFK'),
        (4, 'SEA'),
        (5, 'OHR'),
        (6, 'LHR')

INSERT INTO
	Flightline ($from_id, $to_id, Name, Route)
SELECT
	f.$NODE_ID,
	t.$NODE_ID,
	a.Name,
    a.Route
FROM (VALUES ('BEG', 'FRA', 'BF-4019', NULL),
            ('BEG', 'LHR', 'BL-502', NULL),
            ('BEG', 'JFK', 'BJ-1002', NULL),
            ('FRA', 'SEA', 'FS-401', NULL),
            ('JFK', 'SEA', 'JS-772', GEOGRAPHY::STGeomFromText('LINESTRING(-122.58797797518645 47.47412022983742,-76.62118110018645 35.19352895108936,-71.17196235018645 42.76472876523594)', 4326)),
            ('JFK', 'OHR', 'JO-401', NULL),
            ('OHR', 'SEA', 'OS-431', GEOGRAPHY::STGeomFromText('LINESTRING(-122.32430610018645 47.11646707768522,-92.88094672518645 39.86080982410391,-87.69539985018645 41.85480238479831)', 4326)),
            ('LHR', 'OHR', 'LO-9301', NULL),
            ('LHR', 'SEA', 'LS-702', NULL)
        ) as a (FromAirport, ToAirport, name, Route)
	JOIN Airport f ON f.Name = a.FromAirport
	JOIN Airport t ON t.Name = a.ToAirport;

GO

/*
	Spatial index
    -- Note: Table must have a primary key for the spatial index
*/
CREATE SPATIAL INDEX SI_Flightline_Routes  
   ON Flightline(Route)  
   USING GEOGRAPHY_GRID  
   WITH (  
    GRIDS = ( MEDIUM, LOW, MEDIUM, HIGH ),  
    CELLS_PER_OBJECT = 64,  
    PAD_INDEX  = ON
);
