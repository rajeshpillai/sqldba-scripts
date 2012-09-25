/*
Problem
Sometimes things that seem complicated are much easier then you think and this is the power of using T-SQL 
to take care of repetitive tasks.  One of these tasks may be the need to backup all databases on your server.   
This is not a big deal if you have a handful of databases, but I have seen several servers where there are 
100+ databases on the same instance of SQL Server.  You could use Enterprise Manager to backup the databases 
or even use Maintenance Plans, but using T-SQL is a much simpler and faster approach.

Solution
With the use of T-SQL you can generate your backup commands and with the use of cursors you can cursor 
through all of your databases to back them up one by one.  This is a very straight forward process and 
you only need a handful of commands to do this. 

Here is the script that will allow you to backup each database within your instance of SQL Server.  
You will need to change the @path to the appropriate backup directory and each backup file will take 
on the name of "DBnameYYYDDMM.BAK".
*/

DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name 

SET @path = 'C:\Backup\'  

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
       BACKUP DATABASE @name TO DISK = @fileName  

       FETCH NEXT FROM db_cursor INTO @name   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor

/*
In this script we are bypassing the system databases, but these could easily be included as well.  You could also change this into a stored procedure and pass in a database name or if left NULL it backups all databases.  Any way you choose to use it, this script gives you the starting point to simply backup all of your databases.

Next Steps

Add this script to your toolbox
Modify this script and make it a stored procedure to include one or many parameters
Enhance the script to use additional BACKUP options
*/