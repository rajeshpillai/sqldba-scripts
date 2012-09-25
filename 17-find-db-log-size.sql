select db_name(database_id) as dbname, type_desc,(size * 8) /1024 as size_MB, (size * 8) /1024/1024 as size_GB 
	from sys.master_files order by name

