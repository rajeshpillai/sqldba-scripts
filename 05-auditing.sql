/* 
Having worked with multiple customers and different application where at times the data 
in the table has gotten changed and we need to find out when/where/who made the changes, I used the below T-SQL code to setup a trigger on the table and track the changes into an auditing table. There are obviously other ways to do this like SQL Profiler, XEvents etc., but I find using T-SQL more simpler and lesser overhead. So, sharing the script for others to use. 
*/

-- Note: This trigger tracks Updates and Deletes happening on a table. 
-- Please delete this trigger once the source has been identified and corrective actions have been taken.

-- 1. Creating the audit table to store information on Update/Delete
CREATE TABLE AuditTable
(
AuditID [int] IDENTITY(1,1) NOT NULL,
Timestamp datetime not null CONSTRAINT AuditTable_Timestamp DEFAULT (getdate()),
OperationType char(1),
OperationDate datetime DEFAULT (GetDate()), 
PrimaryKeyValue varchar(1000), 
OldColValue varchar(200), 
NewColValue varchar(200), 
UserName varchar(128),
AppName varchar(128),
ClientName varchar(128)
)
go

--2. Creating  the audit trigger
-- Replace PrimaryKeyValue with the PK Column Name
-- Replace NewColValue with the column name in the IF BLOCK
-- Replace OldColValue with the column name in the final SELECT statement
-- Replace TBLNAME with the name of your table which you want to track the changes for.

Create trigger TBLNAME_Audit on TBLNAME for update, delete
AS
declare @OperationType char(1),
@OperationDate datetime,
@NewColValue varchar(200),
@OldColValue varchar(200),
@UserName varchar(128),
@AppName varchar(128),
@ClientName varchar(128)

select @UserName = system_user
select @OperationDate = CURRENT_TIMESTAMP
select @ClientName = HOST_NAME()
select @AppName = APP_NAME()

if exists (select * from deleted)
      if exists (select * from inserted)
      begin
            select @OperationType = 'U'
            select @NewColValue = select NewColValue from inserted
      end
      else
      begin
            select @OperationType = 'D'
            select @NewColValue = null
      end
      
Insert AuditTable (OperationType, OperationDate, PrimaryKeyValue, OldColValue, NewColValue, UserName, AppName, ClientName)
select @OperationType, @OperationDate, PrimaryKeyValue, OldColValue, @NewColValue, @UserName, @AppName, @ClientName
from deleted
go

--3. Query the audit table once the values in the base table has changed
select * from AuditTable