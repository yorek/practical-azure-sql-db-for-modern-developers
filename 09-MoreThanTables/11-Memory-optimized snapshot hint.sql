/*
	Using snapshot isolation on memory-optimized table
*/
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

BEGIN TRANSACTION;  -- Explicit transaction.

-- Employees is a memory-optimized table.
SELECT *
FROM dbo.Employees as e WITH (SNAPSHOT)  -- Table hint.

COMMIT TRANSACTION;