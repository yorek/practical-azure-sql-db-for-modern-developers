-- Use WideWorldImporters database
-- Use WideWorldImporters database

/*
	Take a look at existing values
*/
SELECT * FROM [Warehouse].[Colors];

/*
	Insert a new value
*/
INSERT INTO 
	[Warehouse].[Colors] ([ColorID], [ColorName], [LastEditedBy])
VALUES
	(99, 'Unknown', 1);

/*
	Update inserted color
*/
UPDATE
	[Warehouse].[Colors]
SET
	[ColorName] = 'Out of space'
WHERE
	[ColorID] = 99;

/*
	Delete color
*/
DELETE FROM
	[Warehouse].[Colors]
WHERE
	[ColorID] = 99;

/*
	Merge several colors into existing table
*/
MERGE INTO
	[Warehouse].[Colors] AS [target]
USING
	(VALUES 
		(50, 'Deep Sea Blue'),
		(51, 'Deep Sea Light Blue'),
		(52, 'Deep Sea Dark Blue')
	) [source](Id, [Name])
ON
	[target].[ColorID] = [source].[Id]
WHEN MATCHED THEN
	UPDATE SET [target].[ColorName] = [source].[Name]
WHEN NOT MATCHED THEN
	INSERT ([ColorID], [ColorName], [LastEditedBy]) VALUES ([source].Id, [source].[Name], 1)
WHEN NOT MATCHED BY SOURCE AND [target].[ColorID] BETWEEN 50 AND 100 THEN
	DELETE
;
