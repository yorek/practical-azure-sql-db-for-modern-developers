/*
	Creating memory-optimized table-value function:
*/
DROP FUNCTION IF EXISTS dbo.PeopleData;
GO

CREATE FUNCTION dbo.PeopleData(@json nvarchar(max))
RETURNS TABLE
WITH NATIVE_COMPILATION, SCHEMABINDING
AS RETURN (
 SELECT Title, HireDate, PrimarySalesTerritory,
        CommissionRate, OtherLanguages
 FROM OPENJSON(@json)
      WITH(Title nvarchar(50),
           HireDate datetime2,
           PrimarySalesTerritory nvarchar(50),
           CommissionRate float,
           OtherLanguages nvarchar(max) AS JSON)
)