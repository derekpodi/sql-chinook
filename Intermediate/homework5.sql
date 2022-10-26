--Derek Podimatis

USE Chinook;

--1
SELECT CEILING(RAND()*100) + 100 AS RandomNumber


--2
SELECT
    T.TrackId
    ,T.Name
    ,CEILING(RAND(CAST(NEWID() AS varbinary))*3000) AS RandomByRow
FROM Track T
ORDER BY RandomByRow DESC


--3
SELECT
    *
    ,ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomUniqueID
FROM Artist


--4
