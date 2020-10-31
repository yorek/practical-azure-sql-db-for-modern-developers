-- Use WideWorldImporters database

/*
	Enable Change Tracking on Database
*/
ALTER DATABASE WideWorldImportersStandard
SET CHANGE_TRACKING = ON 
(CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)  
GO

/*
	Enable Change Tracking on Colors Table
*/
ALTER TABLE [Warehouse].[Colors]
ENABLE CHANGE_TRACKING  
GO

/*
	Get Current Change Tracking Version.
	Make sure to write this number down somewhere 
	as it will be needed later
*/
SELECT CHANGE_TRACKING_CURRENT_VERSION()   
GO

/*
	Update a color
*/
UPDATE [Warehouse].[Colors] 
SET ColorName = 'Test' 
WHERE ColorID = 10;
GO

/*
	Insert a couple of new colors
*/
INSERT INTO [Warehouse].[Colors] ([ColorID], [ColorName], [LastEditedBy])
VALUES 
(100, 'Blue Metal', 1),
(101, 'Dark Brown Green', 1);
go

/*
	Delete a color
*/
DELETE FROM  [Warehouse].[Colors] WHERE ColorID = 30;
go

/*
	Get all changes. In @fromVersion set the number returned by
	the previous call to CHANGE_TRACKING_CURRENT_VERSION()
*/
DECLARE @fromVersion INT = 3;
SELECT 
	SYS_CHANGE_OPERATION, ColorID
FROM 
	CHANGETABLE(CHANGES [Warehouse].[Colors], @fromVersion) C
go

/*
	Get  Current Change Tracking Version
*/
SELECT CHANGE_TRACKING_CURRENT_VERSION();   
GO

/*
	Update a color
*/
UPDATE [Warehouse].[Colors] 
SET ColorName = 'Deep Blue' 
WHERE ColorID = 10;
GO

/*
	Get all changes. In @fromVersion set the number returned by
	the previous call to CHANGE_TRACKING_CURRENT_VERSION()
*/
DECLARE @fromVersion INT = 5;
SELECT 
	SYS_CHANGE_OPERATION, ColorID
FROM 
	CHANGETABLE(CHANGES [Warehouse].[Colors], @fromVersion) C
go

/*
	Disable Change Tracking on Table
*/
ALTER TABLE [Warehouse].[Colors]
DISABLE CHANGE_TRACKING  
GO

/*
	Disable Change Tracking on Database
*/
ALTER DATABASE WideWorldImportersStandard
SET CHANGE_TRACKING = OFF
GO





