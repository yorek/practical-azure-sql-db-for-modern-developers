/*
	Creating memory-optimized hash table
*/
DROP TABLE IF EXISTS dbo.Employees;
GO

CREATE TABLE dbo.Employees(
	EmpID int NOT NULL
		CONSTRAINT PK_Employees_EmpID PRIMARY KEY
		NONCLUSTERED HASH (EmpID) WITH (BUCKET_COUNT = 100000),
	EmpName varchar(50) NOT NULL,
	EmpAddress varchar(50) NOT NULL,
	EmpDepartmentID int NOT NULL,
	EmpBirthDay datetime NULL
) WITH (MEMORY_OPTIMIZED = ON)
GO

-- Sample code that populates the table
INSERT INTO dbo.Employees(EmpID,  EmpName, EmpAddress, EmpDepartmentID)
VALUES  (1, 'Davide', '1st street', 1), (2, 'Anna', '2nd street', 2),
        (3, 'Silvano', '3rd street', 1), (4, 'Sanjay', '4th street', 1),
        (5, 'Jovan', '5th street', 3)
GO



