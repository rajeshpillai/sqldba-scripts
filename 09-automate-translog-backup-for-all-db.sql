/*
Problem
Maintenance plans are a great thing, but sometimes the end results are not what you expect.  The whole idea behind 
maintenance plans is to simplify repetitive maintenance tasks without you having to write any additional code.  
For the most part maintenance plans work without a problem, but every once in awhile things do not go as planned. 
Two of the biggest uses of maintenance plans are issuing full backups and transaction log backups.  
What other approaches are there to issue transaction log backups for all databases without using a maintenance plan? 

Solution
With the use of T-SQL you can generate your transaction log backups and with the use of cursors you can 
cursor through all of your databases to back them up one by one. With the use of the DATABASEPROPERTYEX 
function we can also just address databases that are either in the FULL or BULK_LOGGED recovery model 
since you can not issue transaction log backups against databases in the SIMPLE recovery mode.

Here is the script that will allow you to backup the transaction log for each database within your instance 
of SQL Server that is either in the FULL or BULK_LOGGED recovery model.

You will need to change the @path to the appropriate backup directory and each backup file will take on 
the name of "DBname_YYYDDMM_HHMMSS.TRN".
*/

DECLARE @name VARCHAR(50) -- database name   
DECLARE @path VARCHAR(256) -- path for backup files   
DECLARE @fileName VARCHAR(256) -- filename for backup   
DECLARE @fileDate VARCHAR(20) -- used for file name  

SET @path = 'C:\Backup\'   

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)  
   + '_'  
   + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','') 

DECLARE db_cursor CURSOR FOR   
SELECT name  
FROM master.dbo.sysdatabases  
WHERE name NOT IN ('master','model','msdb','tempdb')  
   AND DATABASEPROPERTYEX(name, 'Recovery') IN ('FULL','BULK_LOGGED') 

OPEN db_cursor    
FETCH NEXT FROM db_cursor INTO @name    

WHILE @@FETCH_STATUS = 0    
BEGIN    
       SET @fileName = @path + @name + '_' + @fileDate + '.TRN'   
       BACKUP LOG @name TO DISK = @fileName   

       FETCH NEXT FROM db_cursor INTO @name    
END    

CLOSE db_cursor    
DEALLOCATE db_cursor 

/*
In this script we are bypassing the system databases, but these could easily be included as well. You could also change this into a stored procedure and pass in a database name or if left NULL it backups all databases. Any way you choose to use it, this script gives you the starting point to simply backup all of your databases.

Next Steps

Add this script to your toolbox
Modify this script and make it a stored procedure to include one or many parameters
Create a scheduled task to backup your transaction logs on a set schedule
Take a look at this tip that does FULL backups for all databases.
Send your improved script to tips@mssqltips.com and we will post it on the site for others to use
*/