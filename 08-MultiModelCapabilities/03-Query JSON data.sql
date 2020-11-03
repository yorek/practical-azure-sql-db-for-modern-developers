/*
	Parse JSON text stored in log column using OPENJSON function to create report.
*/
WITH cte AS 
(
	SELECT
		*
	FROM 
		dbo.Logs l
	CROSS APPLY
		OPENJSON(l.log) WITH (
			duration INT,
			ip VARCHAR(16),
			severity int
		)
)
SELECT
	c.ip,
	c.severity,
	AVG(c.duration) AS [avg_duration]
FROM 
	cte c
GROUP BY
	severity, ip
HAVING 
	AVG(c.duration) > 100
ORDER BY 
	AVG(c.duration);