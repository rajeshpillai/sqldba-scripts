SELECT [avg_fragmentation_in_percent] FROM
	sys.dm_db_index_physical_stats(DB_ID('tdcc_4_83'),
	OBJECT_ID('ebMainTransaction'), 1, NULL, 'LIMITED');

GO



