/*
	JSON data is stored in a table as NVARCHAR column.
*/
DROP TABLE IF EXISTS dbo.Logs;
CREATE TABLE dbo.Logs
(
    [_id] BIGINT NOT NULL IDENTITY
   ,[logDate] DATETIME2(7) NOT NULL
   ,[log] NVARCHAR(MAX) NOT NULL
);
GO

/*
	Optionally, set CHECK constraint that will verify that text in NVARCHAR colum is formatted as JSON.
*/
ALTER TABLE dbo.Logs
ADD
    CONSTRAINT [Data should be formatted as JSON] CHECK (ISJSON([log]) = 1);
GO

/*
	Optionally, create an index on some value in JSON text.
*/
ALTER TABLE dbo.Logs
ADD
    [$severity] AS CAST(JSON_VALUE([log], '$.severity') AS TINYINT);
GO

CREATE INDEX [ix_severity] ON dbo.Logs ([$severity]);
GO

/*
	Insert sample data
*/
INSERT INTO 
	dbo.Logs ([logDate], [log]) 
VALUES
	(SYSDATETIME(), '{"severity": 10, "duration": 300, "ip": "192.168.0.1"}'),
	(SYSDATETIME(), '{"severity": 20, "duration": 50, "ip": "192.168.0.3"}'),
	(SYSDATETIME(), '{"severity": 30, "duration": 1200, "ip": "192.168.0.1"}'),
	(SYSDATETIME(), '{"severity": 40, "duration": 30, "ip": "192.168.0.2"}')
GO

SELECT * FROM dbo.Logs
GO