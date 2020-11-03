/*
	Creating memory-optimized columnstore table
*/
DROP TABLE IF EXISTS dbo.Accounts;
GO

CREATE TABLE dbo.Accounts (
     AccountKey int NOT NULL PRIMARY KEY NONCLUSTERED,
     Description nvarchar (50),
     Type nvarchar(50),
     UnitSold int,
     INDEX cci CLUSTERED COLUMNSTORE
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)



