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


--4  ****INCORRECT****
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,SUM(I.Total) AS TotalSales
    ,CASE
        WHEN MT.MediaTypeId = 3 THEN 'Video'
        ELSE 'Audio'
        END AS Media
    ,RANK() OVER (PARTITION BY CASE
        WHEN MT.MediaTypeId = 3 THEN 'Video'
        ELSE 'Audio'
        END ORDER BY SUM(I.Total))
    ,DENSE_RANK() OVER (PARTITION BY CASE
        WHEN MT.MediaTypeId = 3 THEN 'Video'
        ELSE 'Audio'
        END ORDER BY SUM(I.Total))
FROM Artist A 
JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
JOIN Track T 
    ON T.AlbumId = AL.AlbumId
JOIN MediaType MT 
    ON MT.MediaTypeId = T.MediaTypeId
JOIN InvoiceLine IL 
    ON IL.TrackId = T.TrackId
JOIN Invoice I 
    ON I.InvoiceId = IL.InvoiceId
GROUP BY A.Name, AL.Title, MT.MediaTypeId
HAVING SUM(I.Total) > 15
