--For the packet size, I was referring to the network packet size for the connection.  You can see this in dm_exec_connections:
--Network Packet sizes larger than 8000 bytes are multipage allocated and take additional memory in SQL Server.

SELECT * 
FROM sys.dm_exec_connections
WHERE net_packet_size > 8000

 