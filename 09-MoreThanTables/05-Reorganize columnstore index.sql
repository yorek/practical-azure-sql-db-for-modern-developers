/*
	Reorganizes CLUSTERED COLUMNSTORE index
*/
ALTER INDEX cci
	ON dbo.Orders
		REORGANIZE;