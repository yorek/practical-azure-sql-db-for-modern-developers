-- Use WideWorldImporters database

/*
	Make sure table is in the expected state
*/
DELETE FROM [Warehouse].[Colors] WHERE [ColorID] = 99;
GO

/*
	Insert a new row and output the inserted values
*/
INSERT INTO 
	[Warehouse].[Colors] ([ColorID], [ColorName], [LastEditedBy])
OUTPUT
	[Inserted].*
VALUES
	(99, 'Unknown', 1)
GO

/*
	Update date and output current and previous value
*/
UPDATE
    [Warehouse].[Colors]
SET
    [ColorName] = 'Out of space'
OUTPUT
	[Inserted].[ColorID],
	[Inserted].[ColorName] AS CurrentColorName,
	[Deleted].[ColorName] AS OldColorName
WHERE
    [ColorID] = 99;
GO

/*
	Delete sample data and return deleted values
*/
DELETE FROM [Warehouse].[Colors]
OUTPUT [Deleted].*
WHERE [ColorID] = 99;
