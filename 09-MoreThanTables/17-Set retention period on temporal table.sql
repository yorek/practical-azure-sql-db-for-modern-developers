/*
	Database history retention
	This query enables automatic data retention rules on system versioned tables.
*/
ALTER DATABASE current
      SET TEMPORAL_HISTORY_RETENTION ON;

/*
	Data retention
	This query enables automatic data retention on system versioned tables.
*/
ALTER TABLE dbo.Employee
      SET (SYSTEM_VERSIONING = ON (HISTORY_RETENTION_PERIOD = 9 MONTHS) );


