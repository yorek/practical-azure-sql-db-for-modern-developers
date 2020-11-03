/*
	Error correction on system versioned table
	This query finds a version of row in Employee table
	with the specified identifier and point in time in history
	and overwrites the current cells in the row
*/

DECLARE @asOf datetime2 = DATEADD(MINUTE, -1, GETUTCDATE());
DECLARE @EmployeeID int = 1;

-- Step 1 - "accidentally" enter wrong values
UPDATE
    Employee
SET
    Position = NULL,
	Department = NULL,
	Address = ''
WHERE
    EmployeeID = @EmployeeID;

-- Step 2 - Verify  that you see wrong values
SELECT
    EmployeeID, Position, Department, Address
FROM
    Employee E
WHERE
	E.EmployeeID = @EmployeeID

-- Step 3 - Make corection by overwriting data with older version
UPDATE
	E
SET
	Position = History.Position,
	Department = History.Department,
	Address = History.Address,
	AnnualSalary = History.AnnualSalary
FROM
	Employee AS E
JOIN
	Employee FOR SYSTEM_TIME AS OF @asOf AS History
	ON E.EmployeeID = History.EmployeeID
WHERE
	E.EmployeeID = @EmployeeID

-- Step 4 - See recovered data
SELECT
    EmployeeID, Position, Department, Address
FROM
    Employee E
WHERE
	E.EmployeeID = @EmployeeID
