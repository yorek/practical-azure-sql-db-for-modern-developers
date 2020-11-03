/*
	Creating memory-optimized key-value pairs table for caching purposes (drop existing if needed)
*/
DROP TABLE IF EXISTS Cache;
GO
CREATE TABLE Cache (
	[key] BIGINT IDENTITY,
	value NVARCHAR(MAX),
	INDEX IX_Hash_Key HASH ([key]) WITH (BUCKET_COUNT = 100000)  
) WITH (
	MEMORY_OPTIMIZED = ON,
	DURABILITY = SCHEMA_ONLY
);