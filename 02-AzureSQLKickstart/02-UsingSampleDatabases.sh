###########################################################################
# Various ways of using samples in Azure SQL
###########################################################################

# You can use either Linux Shell, WSL or Azure Cloud Shell (in-browser)
# WSL: https://docs.microsoft.com/en-us/windows/wsl/install-win10
# Azure Cloud Shell: https://shell.azure.com/
# Note - you must have an Azure subscription first
# You can download the sample databases from here:
# https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0

###########################################################################
# Option 1: Deploy Azure SQL Database with AdventureWorksLT
###########################################################################
# create an Azure SQL Database with the default configuration
# and the AdventureWorksLT sample database
az sql db create \
    --name <DatabaseName> \
    --resource-group <ResourceGroupName> \
    --server <LogicalServerName> \
    --sample-name AdventureWorksLT

###########################################################################
# Option 2: Import a bacpac into Azure SQL Database
###########################################################################
# Note - you must already have a database as well as a 
# bacpac file in an Azure Storage Account
az sql db import \
    -g <ResourceGroupName> \
    -s <LogicalServerName> \
    -n <SqlDatabaseName> \
    -u <AdminUsername> \
    -p <AdminPassword> \
    --storage-key-type StorageAccessKey \
    --storage-key <StorageKey> \    
    --storage-uri https://<StorageAccount>.blob.core.windows.net/<BacpacFilename>

# Note: A more complete sample is available in "RestoreFromBacPac" folder

###########################################################################
# Option 3: Restoring a backup file from URL to Azure SQL Managed Instance
###########################################################################
# Note - you must already have an instance deployed
# You must already have a .bak file in an Azure Storage Account
# Details in "RestoreFromBackup" folder