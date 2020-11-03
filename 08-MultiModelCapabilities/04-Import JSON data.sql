/*
	Using values from the JSON document in a query.
*/
CREATE OR ALTER PROCEDURE dbo.InsertDeviceLog
(@msg NVARCHAR(MAX))
AS
INSERT INTO dbo.Logs
	(logDate, log)
SELECT
    j.logDate,
	j.log
FROM
    OPENJSON(@msg)
    WITH
    (
        logDate DATETIME2 '$.properties.logDate'
       ,log NVARCHAR(MAX) '$.info' AS JSON
    ) AS j;
GO


dbo.InsertDeviceLog '{
	"properties": {
		"logDate": "2020-09-19 19:40:32.323"
	},
	"info": {
		"severity": 10, 
		"duration": 300, 
		"ip": "192.168.0.100"
	}
}'
GO

SELECT * FROM dbo.Logs WHERE JSON_VALUE(log, '$.ip') = '192.168.0.100'
GO
