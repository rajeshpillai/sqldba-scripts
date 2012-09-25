/******************************************************************
--File Name    : blocked.sql
-- Author       : Jack Vamvas
-- Description  :processes which are blocked, which processes are blocking other processes
-- Last Modified:19/03/2007
******************************************************************/
SELECT * FROM dbo.sysprocesses WHERE blocked <> 0;
SELECT * FROM dbo.sysprocesses WHERE spid IN (SELECT blocked FROM dbo.sysprocesses where blocked <> 0);
