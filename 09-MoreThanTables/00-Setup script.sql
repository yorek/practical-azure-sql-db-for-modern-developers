IF ( 0 = (SELECT COUNT(*) FROM sys.schemas WHERE name = 'Sales'))
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA Sales';
END
GO
DROP TABLE IF EXISTS Sales.Products;
GO
CREATE TABLE Sales.Products(
       ProductID int,
       State varchar(20),
       Price float
);
GO
CREATE TABLE dbo.Sales(
       SalesID int,
       Price float,
       Description nvarchar(4000),
       State varchar(20),
       Quantity int,
       [Date] date,
       Reference varchar(20)
)
GO

CREATE TABLE Employee (
	EmployeeID int PRIMARY KEY                              ,
	Name varchar(50) NOT NULL,
	Address varchar(50) NOT NULL,
	BirthDay datetime NULL,
       Position varchar(50) NULL,
       Department varchar(50) NULL,
       AnnualSalary float NULL,
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
) WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.EmployeeHistory) );
GO

INSERT INTO Sales.Products(ProductID, State, Price)
VALUES  (1,'Available', 12.7), (2,'Available', 25.2),
        (3,'Available', 18.5), (4,'Not available', NULL),
        (5,'In Stock', 10.5), (6,'In Stock', 37.4)
GO

INSERT INTO dbo.Employee(EmployeeID,  Name , Address, Position, Department)
VALUES  (1, 'Davide', '1st street', 'Program Manager', 'Azure SQL'),
        (2, 'Anna', '2nd street', 'Data Scientist', NULL),
        (3, 'Silvano', '3rd street', 'Program Manager', 'Azure SQL'),
        (4, 'Sanjay', '4th street', NULL , 'Azure SQL'),
        (5, 'Jovan', '5th street', NULL, NULL)
GO
