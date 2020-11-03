/*
	Temporal query on system versioned table
	This query finds a version of a row in Employee table
	with the specified identifier and point in time in history
*/
DECLARE @asOf datetime2 = '2020-10-10';
DECLARE @EmployeeID int = 42;

SELECT
	*
FROM
	dbo.Employee FOR SYSTEM_TIME AS OF @asOf AS History
WHERE
	EmployeeID = @EmployeeID
