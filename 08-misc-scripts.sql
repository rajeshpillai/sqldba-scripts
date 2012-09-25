/*
1. Find Column Names
*/
SELECT t.name AS table_name, SCHEMA_NAME(schema_id) AS schema_name,
    c.name AS column_name
    FROM sys.tables AS t
    INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID 
    WHERE c.name like '%Brn%' 
    ORDER BY schema_name, table_name;

GO
    
/*
2. Search inside stored procedures
*/
SELECT Name FROM sys.procedures
	WHERE OBJECT_DEFINITION(object_id) LIKE '%ebCustomer%'

GO




    