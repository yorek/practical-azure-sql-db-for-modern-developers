-- Use WideWorldImporters database

/*
	Make sure sample objects doesn't exists already
*/
DROP TABLE IF EXISTS dbo.PostTags;
DROP PROCEDURE IF EXISTS dbo.AddTagsToPost;
DROP TYPE IF EXISTS dbo.PostTagsTableType ;
GO

/*
	Create sample table
*/
CREATE TABLE dbo.PostTags
(
	PostId INT NOT NULL,
	Tag NVARCHAR(100) NOT NULL,
	CONSTRAINT pk__Samples__PostTags 
		PRIMARY KEY CLUSTERED (PostId, Tag)
);
GO

/*
	Create Table Variable
*/
CREATE TYPE dbo.PostTagsTableType AS TABLE
(
	Tag NVARCHAR(100) NOT NULL UNIQUE
);
GO

/*
	Create Stored Procedure that uses the created Table Variable
*/
CREATE PROCEDURE dbo.AddTagsToPost
@PostId INT,
@Tags dbo.PostTagsTableType READONLY
AS
INSERT INTO dbo.PostTags
SELECT @PostId, Tag FROM @Tags 
GO

/*
	Use TVP from T-SQL
*/
DECLARE @tvp AS dbo.PostTagsTableType;
INSERT INTO @tvp (Tag) VALUES ('T-SQL'), ('Test'), ('TVP');
EXEC dbo.[AddTagsToPost] 123, @tvp
go

/*
	To use TVP from you app you can find
	samples in the TableValueParameters folder
*/

/*	
	View table content
*/
SELECT * FROM dbo.PostTags
GO
