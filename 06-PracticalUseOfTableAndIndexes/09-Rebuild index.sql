/*
	Rebuilding an index that optimizes a query
*/
ALTER INDEX FK_Sales_Customers_DeliveryCityID
	ON Sales.Customers
		REBUILD WITH ( ONLINE = ON);
GO

/*
	Identify the indexes that need to be rebuilt or reorganized
*/
DECLARE @db_id int = DB_ID();
DECLARE @object_id int = OBJECT_ID('Sales.Customers');

SELECT
	index_id,
	partition_number,
	avg_fragmentation_in_percent
FROM
	sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'LIMITED');   

/*
	Check out also the script provided here:

	- https://github.com/Microsoft/tigertoolbox/tree/master/MaintenanceSolution
	- https://github.com/microsoft/tigertoolbox/tree/master/Index-Information
	- https://github.com/microsoft/tigertoolbox/tree/master/Index-Creation

	Also make sure to check out this post:

	https://stackoverflow.com/questions/48681024/how-to-set-azure-sql-to-rebuild-indexes-automatically
*/