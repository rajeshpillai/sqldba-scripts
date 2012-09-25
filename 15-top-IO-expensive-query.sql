SELECT TOP 10
        [Individual Query] = SUBSTRING(qt.TEXT,
                                       ( qs.statement_start_offset / 2 ) + 1,
                                       ( ( CASE qs.statement_end_offset
                                             WHEN -1 THEN DATALENGTH(qt.TEXT)
                                             ELSE qs.statement_end_offset
                                           END - qs.statement_start_offset )
                                         / 2 ) + 1),
        [Total IO] = ( qs.total_logical_reads + qs.total_logical_writes ),
        [Average IO] = ( qs.total_logical_reads + qs.total_logical_writes ) / qs.execution_count,
        [Execution Count] = qs.execution_count,
        [Total Logical Reads] = qs.total_logical_reads,
        [Total Logical Writes] = qs.total_logical_writes,
        [Total Worker Time/CPU time] = qs.total_worker_time,
        [Total Elapsed Time In Seconds] = qs.total_elapsed_time / 1000000,
        [Parent Query] = qt.text,
        [DatabaseName] = DB_NAME(qt.dbid),
        [Query Plan] = qp.query_plan
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY [Total IO] DESC --IO
-- ORDER BY [Total Elapsed Time In Seconds] DESC  --elapsed time
-- ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time