-- Use WideWorldImporters database

/*
	Table with sensitive data
*/
SELECT PersonId, FullName, EmailAddress FROM [Application].[People]
GO

/*
	Add Dynamic Data Masking to EmailAddress column
*/
ALTER TABLE [Application].[People]
ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')
GO

/*
	Check that user is local administrator (db_owner = 1)
*/
SELECT [user_name] = USER_NAME(), [db_owner] = IS_MEMBER('db_owner')
GO

/*
	Data not masked as by default a db_owner has access to masked data
*/
SELECT PersonId, FullName, EmailAddress FROM [Application].[People]
GO

/*
	Create sample low-priviledged user
*/
CREATE USER TestUser WITHOUT LOGIN;  
GRANT SELECT ON [Application].[People] TO TestUser;  
GO

/*
	Impersonate the created user (this is possibile only if user is local admin)
*/
EXECUTE AS USER = 'TestUser'
GO
SELECT USER_NAME(), IS_MEMBER('db_owner')
GO

/*
	Data is now masked
*/
SELECT PersonId, FullName, EmailAddress FROM [Application].[People]
GO

/*
	User can still use original values
	to seach for data, for example
*/
SELECT PersonId, FullName, EmailAddress FROM [Application].[People] WHERE EmailAddress = 'helenm@fabrikam.com'
GO

/*
	Return to be the local admin
*/
REVERT
GO

/*
	Now allow TestUser to UNMASK data
*/
GRANT UNMASK TO TestUSer;
GO

/*
	Impersonate the created TestUser
*/
EXECUTE AS USER = 'TestUser'
GO
SELECT USER_NAME(), IS_MEMBER('db_owner')
GO

/*
	Data can now be unmasked
*/
SELECT PersonId, FullName, EmailAddress FROM [Application].[People] 
GO

/*
	Revert back to local admin
*/
REVERT
GO

/*
	Drop created TestUser
*/
DROP USER TestUser
GO
