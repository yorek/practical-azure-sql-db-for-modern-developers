/*
	Creating natively compiled procedure
*/
DROP PROCEDURE IF EXISTS dbo.myProcedure;
GO

CREATE PROCEDURE dbo.myProcedure(@p1 int NOT NULL, @p2 nvarchar(5))
WITH NATIVE_COMPILATION, SCHEMABINDING
AS BEGIN ATOMIC WITH
(  TRANSACTION ISOLATION LEVEL = SNAPSHOT,
   LANGUAGE = N'us_english')

  /* Procedure code goes here - example: */
  SELECT a = 1;

END