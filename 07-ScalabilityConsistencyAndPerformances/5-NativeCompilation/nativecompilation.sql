--USE WideWorldImporters-Full 

-- Create an In-memory OLTP optimized table
CREATE TABLE InMemory.VehicleLocations
(
	VehicleLocationID bigint IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
	RegistrationNumber nvarchar(20) NOT NULL,
	TrackedWhen datetime2(2) NOT NULL,
	Longitude decimal(18,4) NOT NULL,
	Latitude decimal(18,4) NOT NULL
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

-- Create a natively compiled stored procedure
CREATE PROCEDURE InMemory.Insert50ThousandVehicleLocations
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC WITH
(
	TRANSACTION ISOLATION LEVEL = SNAPSHOT,
	LANGUAGE = N'English'
)
	DECLARE @Counter int = 0;
	WHILE @Counter < 50000
	BEGIN
		INSERT InMemory.VehicleLocations
			(RegistrationNumber, TrackedWhen, Longitude, Latitude)
		VALUES
			(N'EA-232-JB', SYSDATETIME(), 125.4, 132.7);
		SET @Counter += 1;
	END;
	RETURN 0;
END;
GO

-- Execute a natively compiled stored procedure
EXECUTE InMemory.Insert50ThousandVehicleLocations