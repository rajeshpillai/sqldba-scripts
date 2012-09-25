/*
isusertransaction

1 = The transaction was initiated by a user request.
0 = System transaction
transaction_state

0 = The transaction has not been completely initialized yet.
1 = The transaction has been initialized but has not started.
2 = The transaction is active.
3 = The transaction has ended. This is used for read-only transactions.
4 = The commit process has been initiated on the distributed transaction. This is for distributed transactions only. The distributed transaction is still active but further processing cannot take place.
5 = The transaction is in a prepared state and waiting resolution.
6 = The transaction has been committed.
7 = The transaction is being rolled back.
8 = The transaction has been rolled back.isusertransaction

*/

SELECT 
       est.session_id as [Session ID],
       est.transaction_id as [Transaction ID],
       tas.name as [Transaction Name],
       tds.database_id as [Database ID]
FROM sys.dm_tran_active_transactions tas 
INNER JOIN sys.dm_tran_database_transactions tds 
       ON (tas.transaction_id = tds.transaction_id )
INNER JOIN sys.dm_tran_session_transactions est 
       ON (est.transaction_id=tas.transaction_id)
       WHERE est.is_user_transaction = 1 -- user
       AND tas.transaction_state = 2 -- active
       AND tds.database_transaction_begin_time IS NOT NULL
       -- Time at which the database became involved in the transaction, You can apply filter here