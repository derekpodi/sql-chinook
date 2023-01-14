--Derek Podimatis

USE Chinook;


--1
WITH CTE AS 
(
SELECT
    AlbumId
    ,Name as TrackName
    ,CONCAT('Track',ROW_NUMBER() OVER (PARTITION BY AlbumId ORDER BY TrackId)) AS TrackNumber
FROM Track
)
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,MAX(CASE WHEN T.TrackNumber = 'Track1' THEN T.TrackName END) AS Track1
    ,MAX(CASE WHEN T.TrackNumber = 'Track2' THEN T.TrackName END) AS Track2
    ,MAX(CASE WHEN T.TrackNumber = 'Track3' THEN T.TrackName END) AS Track3
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
JOIN CTE T ON T.AlbumId = AL.AlbumId
GROUP BY A.Name, AL.Title
ORDER BY A.Name


--2
;WITH CTE AS 
(
SELECT
    AlbumId
    ,Name as TrackName
    ,Milliseconds AS TrackLength
    ,CONCAT('Track',ROW_NUMBER() OVER (PARTITION BY AlbumId ORDER BY TrackId)) AS TrackNumber
FROM Track
)
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,MAX(CASE WHEN T.TrackNumber = 'Track1' THEN T.TrackName END) AS Track1
    ,MAX(CASE WHEN T.TrackNumber = 'Track1' THEN T.TrackLength END) AS Track1

    ,MAX(CASE WHEN T.TrackNumber = 'Track2' THEN T.TrackName END) AS Track2
    ,MAX(CASE WHEN T.TrackNumber = 'Track2' THEN T.TrackLength END) AS Track2

    ,MAX(CASE WHEN T.TrackNumber = 'Track3' THEN T.TrackName END) AS Track3
    ,MAX(CASE WHEN T.TrackNumber = 'Track3' THEN T.TrackLength END) AS Track3

FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
JOIN CTE T ON T.AlbumId = AL.AlbumId
GROUP BY A.Name, AL.Title
ORDER BY A.Name


--3
;WITH CTE AS
(
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
    ,COUNT(*) OVER (Partition By T.AlbumId) AS TrackCount
    ,CONCAT('Track', ROW_NUMBER() OVER (PARTITION BY T.AlbumId ORDER BY T.TrackId)) AS TrackNumber
FROM Track T
JOIN Album AL ON AL.AlbumId = T.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
)
SELECT
    ArtistName
    ,AlbumTitle
    ,TrackCount
    ,Track1 , Track2, Track3, Track4, Track5, Track6, Track7, Track8, Track9, Track10, Track11, Track12, Track13, Track14, Track15, Track16, Track17, Track18, Track19, Track20
FROM CTE
PIVOT(
    MAX(TrackName)
    FOR TrackNumber IN (Track1 , Track2, Track3, Track4, Track5, Track6, Track7, Track8, Track9, Track10, Track11, Track12, Track13, Track14, Track15, Track16, Track17, Track18, Track19, Track20)
) AS P
WHERE TrackCount >= 20
ORDER By TrackCount, ArtistName, AlbumTitle


--4
;WITH CTE AS
(
SELECT
    C.CustomerId
    ,C.LastName
    ,YEAR(I.InvoiceDate) AS Year
    ,I.Total 
    ,ROW_NUMBER() OVER (PARTITION BY YEAR(I.InvoiceDate) ORDER BY I.InvoiceId) AS InvoiceNumber
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
WHERE YEAR(I.InvoiceDate) IN (2009, 2011)
)
SELECT
    CustomerId
    ,LastName
    ,SUM(CASE WHEN Year = 2009 THEN CTE.Total ELSE 0 END) AS Total2009
    ,SUM(CASE WHEN Year = 2011 THEN CTE.Total ELSE 0 END) AS Total2011
FROM CTE CTE
GROUP BY CustomerId, LastName


--5
