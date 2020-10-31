###########################################################################
# How to deploy Azure SQL Database using the Azure CLI
###########################################################################

# You can use either a Linux Shell, WSL or Azure Cloud Shell (in-browser)
# WSL: https://docs.microsoft.com/en-us/windows/wsl/install-win10
# Azure Cloud Shell: https://shell.azure.com/
# Note - you must have an Azure subscription first

###########################################################################
# Step 1: Set up Azure CLI and create a resource group
###########################################################################
# log in to your Azure account
az login

# view your available subscriptions
az account list -o table

# copy the subscription ID you want to use and set it as default
az account set --subscription <YourSubscriptionId>

# view regions available to your account, note the "name" of the region you want to use (for example, "westus")
az account list-locations -o table

# create a resource group (specifying region and name)
az group create --location <DeploymentRegion> --name <ResourceGroupName>

###########################################################################
# Step 2: Create an Azure SQL Database
###########################################################################
# create a logical server
az sql server create \
    --admin-password <AdminPassword> \
    --admin-user <AdminUsername> \
    --name <LogicalServerName> \
    --resource-group <ResourceGroupName> \
    --location <DeploymentRegion>

# create an Azure SQL Database with the default configuration
az sql db create \
    --name <DatabaseName> \
    --resource-group <ResourceGroupName> \
    --server <LogicalServerName>

###########################################################################
# Step 3: Create an Azure SQL Database with a sample
###########################################################################
# create an Azure SQL Database with the default configuration
# and the AdventureWorksLT sample database
az sql db create \
    --name <DatabaseName> \
    --resource-group <ResourceGroupName> \
    --server <LogicalServerName> \
    --sample-name AdventureWorksLT

###########################################################################
# Step 4: Create firewall rules
###########################################################################
# get your external ip, for example:
curl https://api.myip.com -s

# create firewall rules to allow connections from your ip
az sql server firewall-rule create \
    --name <FirewallRuleName> \
    --resource-group <ResourceGroupName> \
    --server <LogicalServerName> \
    --start-ip-address <StartIpAddress> \
    --end-ip-address <EndIpAddress>

###########################################################################
# Step 5: (extra) Create Azure SQL managed instance
###########################################################################
# Note: you'll first need to create a virtual network for Managed instance
# Recommend using the guidance in the documentation 
# https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-create-vnet-subnet

# create an azure sql managed instance with default parameters
az sql mi create \
    -g <ResourceGroupName> \
    -n <ManagedInstanceName> \
    -l <DeploymentLocation> \
    -i -u <AdminUsername> -p <AdminPassword> \
    --subnet /subscriptions/<SubcriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Network/virtualNetworks/<VnetName>/subnets/<SubnetName>

# create a new managed database within an existing azure sql managed instance
az sql midb create \
    -g <ResourceGroupName> \
    --mi <ManagedInstanceName> \
    -n <ManagedDatabaseName>

