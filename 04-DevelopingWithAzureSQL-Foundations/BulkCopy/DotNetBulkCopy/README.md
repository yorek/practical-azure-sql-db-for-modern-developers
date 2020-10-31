# .NET Core Bulk Copy Sample

Sample showing how to Bulk Load data into Azure SQL using BulkCopy API available in .NET Core

Before running the sample create a `.env` file using the `.env.template` as a starting point. Azure SQL connection string can be obtained from the Azure Portal or via AZ CLI:

```bash
az sql db show-connection-string -n <DatabaseName> --server <ServerName> -c ado.net
```

The sample will create 100000 on the fly, using the `Bogus` package and will bulk load them in Azure SQL.