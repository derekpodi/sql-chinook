--Derek Podimatis

USE Chinook

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
FROM Artist;


--4
WITH CTE AS
(
 SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,SUM(IL.UnitPrice * IL.Quantity) AS TotalSales
    ,CASE
        WHEN MT.MediaTypeId = 3 THEN 'Video'
        ELSE 'Audio'
        END AS Media
FROM Artist A 
JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
JOIN Track T 
    ON T.AlbumId = AL.AlbumId
JOIN MediaType MT 
    ON MT.MediaTypeId = T.MediaTypeId
JOIN InvoiceLine IL 
    ON IL.TrackId = T.TrackId
GROUP BY A.Name, AL.Title, MT.MediaTypeId
HAVING SUM(IL.UnitPrice * IL.Quantity) > 15
)
SELECT
    ArtistName
    ,AlbumTitle
    ,TotalSales 
    ,Media 
    ,RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS Ranking
    ,DENSE_RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS DenseRanking
FROM CTE;


--5
WITH CTE AS
(
SELECT
    G.Name AS GenreName
    ,AL.Title AS AlbumTitle
    ,SUM(IL.UnitPrice * IL.Quantity) AS TotalSales
    ,RANK() OVER (PARTITION BY G.Name ORDER BY SUM(IL.UnitPrice * IL.Quantity) DESC) AS Ranking
FROM Album AL
JOIN Track T 
    ON T.AlbumId = AL.AlbumId
JOIN Genre G 
    ON G.GenreId = T.GenreId
JOIN InvoiceLine IL
    ON IL.TrackId = T.TrackId
GROUP BY AL.Title, G.Name
HAVING SUM(IL.UnitPrice * IL.Quantity) > 15
)
SELECT
    GenreName
    ,AlbumTitle
    ,TotalSales
    ,Ranking
FROM CTE
WHERE Ranking <=3;


--6
