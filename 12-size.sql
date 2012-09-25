/*
1. How much transaction log space is being used?
*/
SELECT [database_transaction_log_bytes_used] 
	FROM sys.dm_tran_database_transactions
	WHERE [database_id] = DB_ID('tdcc_48_3');

GO

SELECT i.name                  AS IndexName,
    SUM(s.used_page_count) * 8   AS IndexSizeKB
FROM sys.dm_db_partition_stats  AS s 
JOIN sys.indexes                AS i
ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
WHERE s.[object_id] = object_id('dbo.ebCashTransaction')
GROUP BY i.name
ORDER BY i.name

GO

SELECT
    i.name              AS IndexName,
    SUM(page_count * 8) AS IndexSizeKB
FROM sys.dm_db_index_physical_stats(
    db_id(), object_id('dbo.ebCashTransaction'), NULL, NULL, 'DETAILED') AS s
JOIN sys.indexes AS i
ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
GROUP BY i.name
ORDER BY i.name

GO

exec sp_spaceused 'ebCashTransaction', true
GO

exec sp_helpdb
Go
