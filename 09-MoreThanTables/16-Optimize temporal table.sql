/*
	Optimizing temporal tables
	This query optimizes system-versioned history table by adding the following indexes:
	- Clustered columnstore index on history table
	- Nonclustered B-Tree index on time and identifier columns in history table.
*/
CREATE CLUSTERED COLUMNSTORE INDEX cci_EmployeeHistory
	ON dbo.EmployeeHistory;

CREATE NONCLUSTERED INDEX IX_EmployeeHistory_ID_PERIOD_COLUMNS
	ON EmployeeHistory (SysEndTime, SysStartTime, EmployeeID);

