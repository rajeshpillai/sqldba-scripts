/*
Page Life Expectancy threshold
-> (buffer pool size in GB / 4) * 300
For.e.g. For a 100GB buffer pool this would give a threshold
of 7500

*/

SELECT [object_name],[counter_name],[cntr_value]
	FROM sys.dm_os_performance_counters
	WHERE [object_name] LIKE '%Manager%'
	AND [counter_name] = 'Page life expectancy'
	

