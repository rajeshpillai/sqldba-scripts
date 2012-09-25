-- Turn on advanced options
EXEC sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO

-- See what the current value is for 'max server memory (MB)'
EXEC sp_configure

-- Set max server memory = 2300MB for the server
EXEC sp_configure 'max server memory (MB)', 1500
GO
RECONFIGURE
GO