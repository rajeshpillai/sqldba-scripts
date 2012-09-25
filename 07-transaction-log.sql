/*
why the transaction log file keeps growing and growing, this simple query can give you the answer:

--The log_reuse_wait_desc column contains the reason why the SQL Server currently can't reuse the log file of that database.
For Details refer http://msdn.microsoft.com/en-us/library/ms345414.aspx

og_reuse_wait value

log_reuse_wait_desc value

Description

0 NOTHING 
Currently there are one or more reusable virtual log files.

1 CHECKPOINT
No checkpoint has occurred since the last log truncation, or the head of the log has not yet moved beyond a virtual log file (all recovery models).
This is a routine reason for delaying log truncation. For more information, see Checkpoints and the Active Portion of the Log.

2 LOG_BACKUP
A log backup is required to move the head of the log forward (full or bulk-logged recovery models only).
Note	Log backups do not prevent truncation. 
When the log backup is completed, the head of the log is moved forward, and some log space might become reusable.

3 ACTIVE_BACKUP_OR_RESTORE
A data backup or a restore is in progress (all recovery models).
A data backup works like an active transaction, and, when running, the backup prevents truncation. For more information, see "Data Backup Operations and Restore Operations," later in this topic.

4 ACTIVE_TRANSACTION
A transaction is active (all recovery models).
A long-running transaction might exist at the start of the log backup. In this case, freeing the space might require another log backup. For more information, see "Long-Running Active Transactions," later in this topic.
A transaction is deferred (SQL Server 2005 Enterprise Edition and later versions only). A deferred transaction is effectively an active transaction whose rollback is blocked because of some unavailable resource. For information about the causes of deferred transactions and how to move them out of the deferred state, see Deferred Transactions. 

5 DATABASE_MIRRORING
Database mirroring is paused, or under high-performance mode, the mirror database is significantly behind the principal database (full recovery model only).
For more information, see "Database Mirroring and the Transaction Log," later in this topic.

6 REPLICATION
During transactional replications, transactions relevant to the publications are still undelivered to the distribution database (full recovery model only).
For more information, see "Transactional Replication and the Transaction Log," later in this topic.

7 DATABASE_SNAPSHOT_CREATION
A database snapshot is being created (all recovery models).
This is a routine, and typically brief, cause of delayed log truncation.

8 LOG_SCAN
A log scan is occurring (all recovery models).
This is a routine, and typically brief, cause of delayed log truncation.

9 OTHER_TRANSIENT
This value is currently not used.

*/

SELECT name,log_reuse_wait_desc FROM sys.databases;
