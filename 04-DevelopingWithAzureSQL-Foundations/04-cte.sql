-- Use WideWorldImporters database

/*
	CTEs sample
*/
WITH cteOrders AS
(
	SELECT * FROM Sales.[Orders] WHERE SalespersonPersonID = 2
),
cteCustomers AS
(
	SELECT	
		c.CustomerID
	FROM
		Sales.[Customers] AS c
	WHERE
		[CustomerName] = 'Daniel Martensson'
)
SELECT
	OrderId,
	OrderDate,
	(SELECT COUNT(*) FROM Sales.[OrderLines] AS ol WHERE ol.[OrderID] = o.OrderId) AS OrderSize
FROM
	cteOrders AS o
INNER JOIN
	cteCustomers c ON [c].[CustomerID] = [o].[CustomerID]
AND
	OrderDate >= '2015-01-01'
ORDER BY
	[o].[OrderID]
GO

/*
	Recursive CTE sample
	Sample from https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver15#examples
*/

-- Create an Employee table, where a parent-child hierarchy 
-- is defined via EmployeeID and ManagerID columns
CREATE TABLE dbo.MyEmployees  
(  
	EmployeeID smallint NOT NULL,  
	FirstName nvarchar(30)  NOT NULL,  
	LastName  nvarchar(40) NOT NULL,  
	Title nvarchar(50) NOT NULL,  
	DeptID smallint NOT NULL,  
	ManagerID int NULL,  
	constraint PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)   
);  
go

-- Populate the table with values
insert into dbo.MyEmployees 
([EmployeeID], [FirstName], [LastName], [Title], [DeptID], [ManagerID])
values   
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)  
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)  
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)  
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)  
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)  
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)  
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)  
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)  
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 
go

-- Return all employees each one with a "path" string that 
-- shows their position in the organization chart
with [cte] as
(
	-- Anchor Query
    select
        [ManagerID]
       ,[EmployeeID]
       ,[Title]
       ,0 as [EmployeeLevel]
       ,cast('/' as nvarchar(max)) as [ReportPath]
    from
        [dbo].[MyEmployees]
    where
        [ManagerID] is null
    
	union all
    
	-- Recursive Query
	select
        [e].[ManagerID]
       ,[e].[EmployeeID]
       ,[e].[Title]
       ,[EmployeeLevel] + 1
       ,cast(([ReportPath] + cast([e].[EmployeeID] as nvarchar(9)) + N'/') as nvarchar(max)) as [ReportPath]
    from
        [dbo].[MyEmployees] as [e]
    inner join
        [cte] as [d] on [e].[ManagerID] = [d].[EmployeeID]
)
select
    [ManagerID]
   ,[EmployeeID]
   ,[Title]
   ,[EmployeeLevel]
   ,[ReportPath]
from
    [cte]
order by
    [ManagerID];

-- More details on recursive CTE here
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver15#guidelines-for-defining-and-using-recursive-common-table-expressions

-- Beside recursive CTE, if you need to represent hierarchical structures you can also use the HIERARCHYID data type:
-- https://docs.microsoft.com/en-us/sql/relational-databases/hierarchical-data-sql-server?view=sql-server-ver15

