--Derek Podimatis

USE master
IF DB_ID('MyDB_DerekPodimatis') IS NOT NULL
BEGIN
    ALTER DATABASE MyDB_DerekPodimatis SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE MyDB_DerekPodimatis SET ONLINE;
    DROP DATABASE MyDB_DerekPodimatis;
END


--1
CREATE DATABASE MyDB_DerekPodimatis
GO
USE MyDB_DerekPodimatis

--2
