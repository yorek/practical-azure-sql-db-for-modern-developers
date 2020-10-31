# Chapter 11 - DevOps with Azure SQL

Samples for to Chapter 11 of [Practical Azure SQL Database for Modern Developers](https://www.apress.com/gp/book/9781484263693) book.

Taken from the book:
> Creating a full, end-to-end, CI/CD pipeline can be a bit complex the first time.  That’s why in the code accompanying this book you can find an end-to-end sample that shows how to create a simple C# REST API, backed by an Azure SQL Database, and deployed on Azure using Azure Web App. The CI/CD pipeline is created using GitHub and [DbUp](http://dbup.github.io/), and the testing framework used is [NUnit](https://nunit.org/).

## Azure GitHub Actions

### Create a new Azure SQL database

Create a new empty Azure SQL database. Make sure you allow Azure Services to acces the created database, as described here: [Allow Azure services](https://docs.microsoft.com/en-us/azure/azure-sql/database/network-access-controls-overview#allow-azure-services)

### Create a user used for running deployment and tests

Create a user that has enough rights to execute all the needed statements used to deploy the database.  For example

```sql
CREATE USER [github_action_user] WITH PASSWORD = 'S0meVery_Very+Str0ngPazzworD!';
ALTER ROLE ddl_admin ADD MEMBER [github_action_user];
ALTER ROLE db_datareader ADD MEMBER [github_action_user];
ALTER ROLE db_datawriter ADD MEMBER [github_action_user];
```

### Get Azure SQL Connection string

Get the ADO.NET connection string to that database you just created, either via the Portal or [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest#az_sql_db_show_connection_string) or [Powershell]().

The connection will be something like:

```
Server=tcp:<myserver>.database.windows.net,1433;Database=github_action_user;User ID=github_action_user;Password=S0meVery_Very+Str0ngPazzworD!;Encrypt=true;Connection Timeout=30;
```

### Create a new empty GitHub repo

Create a new empty GitHub repository. In Settings/Secrets create a secret named `AZURE_SQL_CONNECTION_STRING` and store the connection string of the Azure SQL database you created in the previous step.

Clone the empty repository into a local folder.

Copy the content of this folder (`11-DevOpsWithAzureSQL`) with the exception of the `.git` folder into the newly created folder. 

### Deploy the solution

Push all the local changes to the remote repository. 

The GitHub Action defined in `.github` folder will kick in, starting a two-step process to deploy and test database using [DbUp](http://dbup.github.io/) and NUnit. Deployment is done via the application in the `db-deploy` folder, while the tests are in the `db-test` folder.

Monitor the GitHub action. If everything worked you will see the deployment done correctly, but the tests failing.

### Release a fix

The stored procedure has a little bug, and in fact the test is failing. A new procedure with a fix is available in the `04-fixed-stored-procedure.sql.fix` files in the `db-deploy/sql` folder. Remove the `.fix` extension so that the new extension will be just `sql` and push this change to the repo.

GitHub Action will start again, deploying only the new script and running the test again.

The test will now both succeed. Well done!

## Debugging Deployment and Testing locally

You can also run deployment and test locally, if you want or need to debug them. To do create a `.env` file starting from the `.env.template` file provided in each folder, and put the Azure SQL connection string, or a connection string to a local SQL Server database if you want to debug everything on-premises.

Then debug the programs a usual using Visual Studio or Visual Studio Code.

## Next Steps

If you want a more complex scenario, you can apply what you have learned to the following sample, forking it into new repository and adding the GitHub action for a complete CI/CD deployment pipeline

https://github.com/Azure-Samples/azure-sql-db-sync-api-change-tracking
