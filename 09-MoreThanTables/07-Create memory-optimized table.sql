/*
	Creating memory-optimized table
*/
DROP TABLE IF EXISTS dbo.Cache;
GO

CREATE TABLE dbo.Cache
(
    [key] INT IDENTITY PRIMARY KEY NONCLUSTERED,
    [data] NVARCHAR(MAX)
)
WITH (MEMORY_OPTIMIZED=ON)