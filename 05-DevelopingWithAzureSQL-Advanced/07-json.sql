-- Use WideWorldImporters database

/*
	Make sure sample objects doesn't exists already
*/
DROP TABLE IF EXISTS dbo.PostTags;
DROP PROCEDURE IF EXISTS dbo.AddTagsToPost;
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
	Create Stored Procedure 
*/
CREATE PROCEDURE dbo.AddTagsToPost
@PostId INT,
@Tags NVARCHAR(MAX)
AS
INSERT INTO dbo.PostTags
SELECT @PostId, T.[value] FROM OPENJSON(@Tags, '$.tags') T
GO

/*
	Use created Stored Procedure	
*/
EXEC dbo.AddTagsToPost 123, '{"tags": ["azure-sql", "string_split", "csv"], "categories": {}}'
GO

/*	
	View table content
*/
SELECT * FROM dbo.PostTags
GO


