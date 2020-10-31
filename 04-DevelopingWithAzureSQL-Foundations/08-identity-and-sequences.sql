/*
	Create a sample table
	with a IDENTITY column
*/
DROP TABLE IF EXISTS dbo.SampleID;
CREATE TABLE dbo.SampleID
(
	Id INT IDENTITY(1,1) NOT NULL,
	OtherColums NVARCHAR(100) NULL
)
GO

/*
	Insert a new row. Value for Id column
	will be added automatically
*/
INSERT INTO dbo.SampleID (OtherColums)
VALUES ('Some value here');

SELECT * FROM dbo.SampleID
GO

/*
	Create a sample table
	now using a SEQUENCE
*/
DROP SEQUENCE IF EXISTS dbo.BookSequence;
CREATE SEQUENCE dbo.BookSequence
AS BIGINT
START WITH 1
INCREMENT BY 1;

DROP TABLE IF EXISTS dbo.SampleID;
CREATE TABLE dbo.SampleID
(
	Id INT NOT NULL DEFAULT(NEXT VALUE FOR dbo.BookSequence),
	OtherColums NVARCHAR(100) NULL
);

/*
	Insert a new row. Value for Id column
	will be added automatically
*/
INSERT INTO dbo.SampleID (OtherColums)
VALUES ('Some value here');

SELECT * FROM dbo.SampleID
GO
