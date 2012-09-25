use tempdb
select (size*8) as FileSizeKB, * from sys.database_files
