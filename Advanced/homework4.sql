--Derek Podimatis

USE Chinook

--Rescources to import files into docker container from host computer
--https://www.quackit.com/sql_server/mac/how_to_copy_a_file_from_the_host_to_a_docker_container.cfm
--https://www.quackit.com/sql_server/mac/how_to_restore_a_bak_file_using_azure_data_studio.cfm
--ls ./Documents/UCSD Extension/Advanced Sql/Lesson 4/Homework 4 Backup Files
--sudo docker exec -it azuresqledge  mkdir /var/opt/mssql/backup
--sudo docker cp WideWorldImporters.bak azuresqledge:/var/opt/mssql/backup
--sudo docker cp HWSimple.bak azuresqledge:/var/opt/mssql/backup
--sudo docker cp HWFull.bak azuresqledge:/var/opt/mssql/backup

--1
USE WideWorldImporters;
RESTORE HEADERONLY
FROM DISK = N'/var/opt/mssql/backup/WideWorldImporters.bak';
GO
    -- DatabaseCreationDate  2022-10-07 14:05:51.000


--2
USE WideWorldImporters;
RESTORE FILELISTONLY
FROM DISK = N'/var/opt/mssql/backup/WideWorldImporters.bak';
GO
    --WWI_Primary

--3
USE WideWorldImporters;
Select
    COUNT(*)
FROM Sales.Invoices
GO
    --70510



--4
----------------------- IMPORT HWSimple SCRIPT -----------------------------
/*
USE [master]
RESTORE DATABASE [HWSimple] FROM  DISK = N'/var/opt/mssql/backup/HWSimple.bak' WITH  FILE = 1,  MOVE N'HWSimple' TO N'/var/opt/mssql/data/HWSimple.mdf',  MOVE N'HWSimple_log' TO N'/var/opt/mssql/data/HWSimple_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [HWSimple] FROM  DISK = N'/var/opt/mssql/backup/HWSimple.bak' WITH  FILE = 3,  NOUNLOAD,  STATS = 5
*/

RESTORE HEADERONLY
FROM DISK = N'/var/opt/mssql/backup/HWSimple.bak';
GO
    -- 5 backup sets  (1 full, 4 differentials)


--5
RESTORE HEADERONLY
FROM DISK = N'/var/opt/mssql/backup/HWSimple.bak';
GO
    --BackupStartDate  2023-02-22 20:28:00.000   (Second Differential)


--6
USE HWSimple;
Select
    COUNT(*)
FROM AlbumTrack
GO
    --179




--7
RESTORE HEADERONLY
FROM DISK = N'/var/opt/mssql/backup/HWFull.bak';
GO
    --2 differential

--8
SELECT 
    SUSER_SNAME([Transaction SID]) AS UserId
    ,[Transaction Name], [Begin Time], [Transaction ID]
    ,[PartitionId], [Lock Information], [Description]
FROM fn_dump_dblog(
    NULL, NULL, 'DISK', 8
    ,N'/var/opt/mssql/backup/HWFull.bak'
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
)
WHERE [Begin Time] IS NOT NULL --AND [Transaction Name] = 'DELETE'
    --Position 8 has the Delete (at time 2023/02/22 20:28:52:880)

--9
/*
USE [master]
RESTORE DATABASE [HWFull] FROM  DISK = N'/var/opt/mssql/backup/HWFull.bak' WITH  FILE = 1,  MOVE N'HWFull' TO N'/var/opt/mssql/data/HWFull.mdf',  MOVE N'HWFull_log' TO N'/var/opt/mssql/data/HWFull_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [HWFull] FROM  DISK = N'/var/opt/mssql/backup/HWFull.bak' WITH  FILE = 7,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [HWFull] FROM  DISK = N'/var/opt/mssql/backup/HWFull.bak' WITH  FILE = 8,  NOUNLOAD,  STATS = 5,  STOPAT = '2023/02/22 20:28:51'
*/
USE HWFull
Select
    COUNT(*)
FROM Invoice
GO
    --195 (at 2023/02/22 20:28:51 right before DELETE)

--10
SELECT 
    SUSER_SNAME([Transaction SID]) AS UserId
    ,[Transaction Name], [Begin Time], [Transaction ID]
    ,[PartitionId], [Lock Information], [Description], *
FROM fn_dump_dblog(
    NULL, NULL, 'DISK', 8
    ,N'/var/opt/mssql/backup/HWFull.bak'
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
    ,DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
)
WHERE [Begin Time] IS NOT NULL


USE HWFull
SELECT Name, SID FROM sys.database_principals
    --Nancy.Edwards



/*
USE HWFull
SELECT SUSER_SNAME(0xAEF2DD89BD54524797D0D56F419F864A)
SELECT SUSER_SNAME()
*/


/*
RESTORE FILELISTONLY
FROM DISK = N'/var/opt/mssql/backup/HWFull.bak';
GO
*/



