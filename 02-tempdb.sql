-- If you want to see all activity in TempDB, just comment out line 14, 
-- which filters out session ID’s 50 or less.  Sessions with ID’s of 50 or less are reserved for SQL Server.

SELECT t1.session_id, t4.login_name, t4.host_name, t1.request_id, t3.TEXT,
	t2.STATUS, t2.command, t2.blocking_session_id, t2.wait_type, t2.wait_time, t2.wait_resource,
	t2.statement_start_offset, t2.statement_end_offset
	FROM (SELECT session_id, request_id,
	SUM(internal_objects_alloc_page_count) AS task_alloc,
	SUM (internal_objects_dealloc_page_count) AS task_dealloc
	FROM sys.dm_db_task_space_usage
	GROUP BY session_id, request_id) AS t1,
	sys.dm_exec_requests AS t2
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS t3
	INNER JOIN sys.dm_exec_sessions AS t4 ON t2.session_id = t4.session_id
	WHERE t1.session_id = t2.session_id
	AND (t1.request_id = t2.request_id)
	AND t1.session_id > 50
	ORDER BY t1.task_alloc DESC

go

SELECT session_id,
	(SUM(user_objects_alloc_page_count)*1.0/128) AS [user object space in MB],
	(SUM(internal_objects_alloc_page_count)*1.0/128) AS [internal object space in MB]
	FROM sys.dm_db_session_space_usage
	GROUP BY session_id
	ORDER BY session_id;

go

SELECT t1.session_id, t1.request_id, t1.task_alloc,
 t1.task_dealloc, t2.sql_handle, t2.statement_start_offset, 
 t2.statement_end_offset, t2.plan_handle
FROM (Select session_id, request_id,
  SUM(internal_objects_alloc_page_count) AS task_alloc,
  SUM (internal_objects_dealloc_page_count) AS task_dealloc 
 FROM sys.dm_db_task_space_usage 
 GROUP BY session_id, request_id) AS t1, 
 sys.dm_exec_requests AS t2
WHERE t1.session_id = t2.session_id
 AND (t1.request_id = t2.request_id)
ORDER BY t1.task_alloc DESC

