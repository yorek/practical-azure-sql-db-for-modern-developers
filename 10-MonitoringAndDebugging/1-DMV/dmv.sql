
-- Top 25 CPU most consuming queries
SELECT TOP 25
    qs.query_hash,
    qs.execution_count,
    REPLACE(REPLACE(LEFT(st.[text], 512), CHAR(10),''), CHAR(13),'') AS
    query_text,
    qs.total_worker_time,
    qs.min_worker_time,
    qs.total_worker_time/qs.execution_count AS avg_worker_time,
    qs.max_worker_time,
    qs.min_elapsed_time,
    qs.total_elapsed_time/qs.execution_count AS avg_elapsed_time,
    qs.max_elapsed_time,
    qs.min_logical_reads,
    qs.total_logical_reads/qs.execution_count AS avg_logical_reads,
    qs.max_logical_reads,
    qs.min_logical_writes,
    qs.total_logical_writes/qs.execution_count AS avg_logical_writes,
    qs.max_logical_writes,
    CASE WHEN CONVERT(nvarchar(max), qp.query_plan) LIKE N'%<MissingIndexes>%' THEN 1 ELSE 0 END AS missing_index,
    qs.creation_time,
    qp.query_plan,
    qs.*
FROM
    sys.dm_exec_query_stats AS qs
CROSS APPLY
    sys.dm_exec_sql_text(plan_handle) AS st
CROSS APPLY
    sys.dm_exec_query_plan(plan_handle) AS qp
WHERE
    st.[dbid]=db_id() and st.[text] NOT LIKE '%sys%'
ORDER BY
    qs.total_worker_time DESC
OPTION (RECOMPILE);

-- Last 10 queries executed on the database
SELECT TOP 10 
    qt.query_sql_text, q.query_id,
    qt.query_text_id, p.plan_id, rs.last_execution_time
FROM 
    sys.query_store_query_text AS qt
    JOIN sys.query_store_query AS q
        ON qt.query_text_id = q.query_text_id
    JOIN sys.query_store_plan AS p
        ON q.query_id = p.query_id
    JOIN sys.query_store_runtime_stats AS rs
        ON p.plan_id = rs.plan_id
ORDER BY 
    rs.last_execution_time DESC;

-- Queries taking more time to execute within the last hour
SELECT TOP 10 
    rs.avg_duration, qt.query_sql_text, q.query_id,
    qt.query_text_id, p.plan_id, GETUTCDATE() AS CurrentUTCTime,
    rs.last_execution_time
FROM 
    sys.query_store_query_text AS qt
    JOIN sys.query_store_query AS q
        ON qt.query_text_id = q.query_text_id
    JOIN sys.query_store_plan AS p
        ON q.query_id = p.query_id
    JOIN sys.query_store_runtime_stats AS rs
        ON p.plan_id = rs.plan_id
WHERE 
    rs.last_execution_time > DATEADD(hour, -1, GETUTCDATE())
ORDER BY 
    rs.avg_duration DESC;

-- Queries executing more I/O reads in the last 24 hours
SELECT TOP 10 
    rs.avg_physical_io_reads, qt.query_sql_text,
    q.query_id, qt.query_text_id, p.plan_id, rs.runtime_stats_id,
    rsi.start_time, rsi.end_time, rs.avg_rowcount, rs.count_executions
FROM 
    sys.query_store_query_text AS qt
    JOIN sys.query_store_query AS q
        ON qt.query_text_id = q.query_text_id
    JOIN sys.query_store_plan AS p
        ON q.query_id = p.query_id
    JOIN sys.query_store_runtime_stats AS rs
        ON p.plan_id = rs.plan_id
    JOIN sys.query_store_runtime_stats_interval AS rsi
        ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE 
    rsi.start_time >= DATEADD(hour, -24, GETUTCDATE())
ORDER BY 
    rs.avg_physical_io_reads DESC;


--- Compare query execution in different time intervals

--- "Recent" workload - last 4 hours
DECLARE @recent_start_time datetimeoffset;
DECLARE @recent_end_time datetimeoffset;
SET @recent_start_time = DATEADD(hour, -4, SYSUTCDATETIME());
SET @recent_end_time = SYSUTCDATETIME();
--- "History" workload – last week
DECLARE @history_start_time datetimeoffset;
DECLARE @history_end_time datetimeoffset;
SET @history_start_time = DATEADD(day, -14, SYSUTCDATETIME());
SET @history_end_time = DATEADD(day, -7, SYSUTCDATETIME());

WITH 
hist AS
(
    SELECT
        p.query_id query_id,
        ROUND(ROUND(CONVERT(FLOAT, SUM(rs.avg_duration * rs.count_executions)) * 0.001, 2), 2) AS total_duration,
        SUM(rs.count_executions) AS count_executions,
        COUNT(distinct p.plan_id) AS num_plans
    FROM sys.query_store_runtime_stats AS rs
        JOIN sys.query_store_plan AS p ON p.plan_id = rs.plan_id
    WHERE (rs.first_execution_time >= @history_start_time
        AND rs.last_execution_time < @history_end_time)
        OR (rs.first_execution_time <= @history_start_time
        AND rs.last_execution_time > @history_start_time)
        OR (rs.first_execution_time <= @history_end_time
        AND rs.last_execution_time > @history_end_time)
    GROUP BY p.query_id
),
recent AS
(
    SELECT
        p.query_id query_id,
        ROUND(ROUND(CONVERT(FLOAT, SUM(rs.avg_duration * rs.count_executions)) * 0.001, 2), 2) AS total_duration,
        SUM(rs.count_executions) AS count_executions,
        COUNT(distinct p.plan_id) AS num_plans
    FROM sys.query_store_runtime_stats AS rs
        JOIN sys.query_store_plan AS p ON p.plan_id = rs.plan_id
    WHERE (rs.first_execution_time >= @recent_start_time
        AND rs.last_execution_time < @recent_end_time)
        OR (rs.first_execution_time <= @recent_start_time
        AND rs.last_execution_time > @recent_start_time)
        OR (rs.first_execution_time <= @recent_end_time
        AND rs.last_execution_time > @recent_end_time)
    GROUP BY p.query_id
)
SELECT
    results.query_id AS query_id,
    results.query_text AS query_text,
    results.additional_duration_workload AS additional_duration_workload,
    results.total_duration_recent AS total_duration_recent,
    results.total_duration_hist AS total_duration_hist,
    ISNULL(results.count_executions_recent, 0) AS count_executions_recent,
    ISNULL(results.count_executions_hist, 0) AS count_executions_hist
FROM
    (
        SELECT
        hist.query_id AS query_id,
        qt.query_sql_text AS query_text,
        ROUND(CONVERT(float, recent.total_duration/recent.count_executions-hist.total_duration/hist.count_executions)*(recent.count_executions), 2) AS additional_duration_workload,
        ROUND(recent.total_duration, 2) AS total_duration_recent,
        ROUND(hist.total_duration, 2) AS total_duration_hist,
        recent.count_executions AS count_executions_recent,
        hist.count_executions AS count_executions_hist
        FROM hist
        JOIN recent
        ON hist.query_id = recent.query_id
        JOIN sys.query_store_query AS q
        ON q.query_id = hist.query_id
        JOIN sys.query_store_query_text AS qt
        ON q.query_text_id = qt.query_text_id
    ) AS results
WHERE 
    additional_duration_workload > 0
ORDER BY 
    additional_duration_workload DESC
OPTION (MERGE JOIN);