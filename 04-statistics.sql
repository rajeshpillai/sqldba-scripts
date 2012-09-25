/*
Controlling STATISTICS Behaviour

You have options like AUTO_UPDATE_STATISTICS, AUTO_CREATE_STATISTICS and AUTO_UPDATE_STATISTICS_ASYNC etc, which are all database level options. So you need to configure this per each database. You can find if your user databases have these options by using sp_helpdb and looking at the status column or by using a query like below.

select name as [DB_NAME], is_auto_create_stats_on, is_auto_update_stats_on, is_auto_update_stats_async_on 
from sys.databases

How to find out which indexes or statistics needs to be updates?
*/

/*
You can use the following query on any SQL 2005+ instance to find out the % of rows modified and based 
on this decide if any indexes need to be rebuilt or statistics on the indexes need to be updated.*/


select
schemas.name as table_schema,
tbls.name as Object_name,
i.id as Object_id,
i.name as index_name,
i.indid as index_id,
i.rowmodctr as modifiedRows,
(select max(rowcnt) from sysindexes i2 where i.id = i2.id and i2.indid < 2) as rowcnt,
convert(DECIMAL(18,8), convert(DECIMAL(18,8),i.rowmodctr) / convert(DECIMAL(18,8),(select max(rowcnt) from sysindexes i2 where i.id = i2.id and i2.indid < 2))) as ModifiedPercent,
stats_date( i.id, i.indid ) as lastStatsUpdateTime
from sysindexes i
inner join sysobjects tbls on i.id = tbls.id
inner join sysusers schemas on tbls.uid = schemas.uid
inner join information_schema.tables tl
on tbls.name = tl.table_name
and schemas.name = tl.table_schema
and tl.table_type='BASE TABLE'
where 0 < i.indid and i.indid < 255
and table_schema <> 'sys'
and i.rowmodctr <> 0
and i.status not in (8388704,8388672)
and (select max(rowcnt) from sysindexes i2 where i.id = i2.id and i2.indid < 2) > 0
order by modifiedRows desc

go

/*
Updating Statistics on all the table in any given database

I often get this often as to how you update all the tables in a database. You can use a script like below to achieve this.

Disclaimer: Do not run this unless you know its implications on a production server. Statistics update on all the tables will use CPU resources and depending on the size of the table take its own time.
*/

select identity(int,1,1) as rownum,table_name into table_count from information_schema.tables where table_type='base table'
declare @count int,@stmt varchar (255),@maxcount int,@tblname varchar(50)
set @count=1
select @maxcount=count(*) from table_count
while @count < @maxcount+1
begin 
      select @tblname=table_name from table_count where rownum=@count
      set @stmt = 'UPDATE STATISTICS '+ '[' +@tblname+ ']' + ' WITH FULLSCAN'
      PRINT ('Updating statistics for table :'+@tblname)
      EXEC(@stmt)
      PRINT ('Finished Updating statistics for table :'+@tblname)
      print ''
      set @count=@count+1
      set @stmt=''
End
drop table table_count

/*
Some tips on Statistics

1. Table variables do not have statistics at all.

Table variables are meant for operations on a small number of rows, a few thousand rows at max. This is a good scenario where you need to think about temporary tables (#tbl), because unlike table variables, temp tables can have indexes created on them, which means they can have statistics.

2. Multi-Statement Table Value Functions (TVF’s) also do not have any statistics

So if you have a complex query logic implemented in a function in SQL Server, think again! This function does not have any statistical information present, so the SQL optimizer must guess the size of the results returned. The reason for this is a multi-statement TVF returns you a TABLE as an output and table does not have any statistics on it.

3. You can find out from the Execution Plan aka SET STATISTICS PROFILE statement if any statistics would help a particular query

When you enable STATISTICS PROFILE ON and execute any query/batch it displays the execution plan. In this output look for the column called “Warnings”. During the course of compiling the plan, if the SQL Server optimizer felt that some statistics on column A would have helped the query, it displays this warning in the execution plan as “NO STATS”. If you see any such warning, consider creating some column statistics or indexes on the particular object in the row.

4. Avoid creating indexes on very frequently updated columns as the statistics also will have to keep up with the amount of data modifications.

5. Viewing Statistics

You can use DBCC SHOW_STATISICS (‘tablename’ , ‘index name’) to view the statistics on any given index’/column stats along with the histogram. The system DMV sys.stats stores information on each statistics available in a particular database.

Any statistics having the name prefixed as _WA_Sys_ is a auto-created statistics, which means SQL Server itself created them. User created statistics will have a given name or have the index name, e.g. PK_TBL1

*/