/*
	Creating Graph tables
*/
DROP TABLE IF EXISTS FlightLine;
GO
DROP TABLE IF EXISTS Airport;
GO

CREATE TABLE Airport (
	AirportID int PRIMARY KEY,
	Name NVARCHAR(100),
	CityID int FOREIGN KEY REFERENCES Application.Cities(CityID)
) AS NODE
GO

CREATE TABLE Flightline (
	Name NVARCHAR(10) 
) AS EDGE;
GO

/*
	Define a constraint that Flightline edge can connect two Airports
*/

ALTER TABLE Flightline
	ADD CONSTRAINT [Connecting airports]
		CONNECTION (Airport TO Airport)
		ON DELETE CASCADE;
GO

/*
	Populate dummy data
*/

DELETE Airport
DELETE FlightLine

INSERT INTO
	Airport (AirportID, Name)
VALUES (1, 'BEG'), (2, 'FRA'),(3, 'JFK'),(4,'SEA'),(5, 'OHR'), (6, 'LHR')

INSERT INTO
	Flightline ($from_id, $to_id, Name)
SELECT
	f.$NODE_ID,
	t.$NODE_ID,
	a.Name
FROM (VALUES ('BEG', 'FRA', 'BF-4019'),
            ('BEG', 'LHR', 'BL-502'),
            ('BEG', 'JFK', 'BJ-1002'),
            ('FRA', 'SEA', 'FS-401'),
            ('JFK', 'SEA', 'JS-772'),
            ('JFK', 'OHR', 'JO-401'),
            ('OHR', 'SEA', 'OS-431'),
            ('LHR', 'OHR', 'LO-9301'),
            ('LHR', 'SEA', 'LS-702')
        ) as a (FromAirport, ToAirport, name)
	JOIN Airport f ON f.Name = a.FromAirport
	JOIN Airport t ON t.Name = a.ToAirport;

