-- Use WideWorldImporters database

/*
	Make sure Table has the default values
*/
UPDATE [Warehouse].[Colors] SET ColorName = 'Azure' WHERE ColorId = 1
DELETE [Warehouse].[Colors] WHERE ColorId > 36
GO

/*
	Define a Trigger on [Warehouse].[Colors] Table
*/
CREATE OR ALTER TRIGGER [Warehouse].[ColorTrigger] ON [Warehouse].[Colors]
FOR UPDATE, DELETE
AS
BEGIN
	IF EXISTS(SELECT * FROM [Deleted] WHERE [ColorName] IN ('Azure')) 
	BEGIN
		IF NOT EXISTS(SELECT * FROM [Inserted] WHERE [ColorName] IN ('Azure'))
		BEGIN
			THROW 50000, 'Azure is here to stay.', 16;
			ROLLBACK TRAN;
		END
	END
END
GO


/*
	Try to delete or update the Azure color
*/
-- That won't work
UPDATE [Warehouse].[Colors] SET ColorName = 'NotAzure' WHERE ColorId = 1;

--Neither this
DELETE FROM [Warehouse].[Colors] WHERE ColorName LIKE 'A%';

--This is fine
INSERT INTO [Warehouse].[Colors] 
	([ColorID], [ColorName], [LastEditedBy])
VALUES
	(999, 'SomeOtherColor', 1)
;

DELETE FROM [Warehouse].[Colors]  WHERE ColorID = 999
;

