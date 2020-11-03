/*
	Loading data into Graph table
*/
INSERT INTO
	Flightline ($from_id, $to_id, Name)
SELECT
	f.$NODE_ID,
	t.$NODE_ID,
	a.Name
FROM OPENROWSET(
		BULK 'data/flightlines.csv',
		DATA_SOURCE = 'MyAzureBlobStorage',
		FORMATFILE='data/flightlines.fmt',
		FORMATFILE_DATA_SOURCE = 'MyAzureBlobStorage') as a
	JOIN Airport f ON f.Name = a.FromAirport
	JOIN Airport t ON t.Name = a.ToAirport;
