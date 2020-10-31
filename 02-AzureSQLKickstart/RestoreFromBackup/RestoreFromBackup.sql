/*
    Sample Environment:

    Backup File is 'WideWorldImporters-Standard.bak' and is available in 'mybakstore1.blob.core.windows.net/db-backups' Azure Blob Store.

    Generate a SAS token on the db-backups folder with at least READ and LIST permission (for example using Azure Storage Explorer)
*/

-- Create a credential to allow Azure SQL MI to access the backup

CREATE CREDENTIAL [https://mybakstore1.blob.core.windows.net/db-backups]
WITH 
IDENTITY = 'SHARED ACCESS SIGNATURE', 
SECRET = '<SasKeyGenerated>' -- REMOVE THE LEADING '?' if present in SAS token string

-- View the files in a backup 
RESTORE FILELISTONLY FROM URL = 'https://mybakstore1.blob.core.windows.net/db-backups/WideWorldImporters-Standard.bak'

-- Restore the database from a URL
RESTORE DATABASE [WideWorldImporters] 
FROM URL = 'https://mybakstore1.blob.core.windows.net/db-backups/WideWorldImporters-Standard.bak'
