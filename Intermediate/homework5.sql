--Derek Podimatis

USE Chinook


--1
SELECT CEILING(RAND() * 101) + 99 AS RandomNumber


--2
SELECT
    TrackId
    ,Name
    ,CEILING(RAND(CAST(NEWID() AS varbinary)) * 3000) AS RandomByRow
FROM Track 
ORDER BY RandomByRow DESC


--3
SELECT
    ArtistId
    ,Name
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
GROUP BY A.Name, AL.Title, CASE WHEN MT.MediaTypeId = 3 THEN 'Video' ELSE 'Audio' END
)
SELECT
    ArtistName
    ,AlbumTitle
    ,TotalSales 
    ,Media 
    ,RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS Ranking
    ,DENSE_RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS DenseRanking
FROM CTE
WHERE TotalSales > 15;


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
WHERE Ranking <= 3
ORDER BY GenreName, Ranking;


--6
WITH CTE AS
(
SELECT 
    A.Name AS ArtistName
    ,SUM(IL.UnitPrice * IL.Quantity) TotalPrice
FROM Artist A 
JOIN Album AL
    ON AL.ArtistId = A.ArtistId
JOIN Track T 
    ON T.AlbumId = AL.AlbumId 
JOIN InvoiceLine IL 
    ON IL.TrackId = T.TrackId
GROUP BY A.Name
)
SELECT 
    ArtistName
    ,TotalPrice
    ,SUM(TotalPrice) OVER (ORDER BY ArtistName) AS RunningTotal
FROM CTE;


--7
WITH CTE AS 
(
SELECT
    I.BillingCountry
    ,SUM(IL.UnitPrice * IL.Quantity) TotalSales
FROM InvoiceLine IL 
JOIN Invoice I 
    ON I.InvoiceId = IL.InvoiceId
GROUP BY I.BillingCountry
)
SELECT
    BillingCountry
    ,TotalSales
    ,NTILE(5) OVER (ORDER BY TotalSales DESC, BillingCountry) AS Quintile
FROM CTE;


--8
WITH CTE AS
(
SELECT
    C.FirstName
    ,C.LastName
    ,C.Country
    ,C.CustomerId
    ,CAST(I.InvoiceDate AS Date) AS InvoiceDate
    ,SUM(IL.UnitPrice * IL.Quantity) AS Total
FROM Customer C
Join Invoice I 
    ON I.CustomerId = C.CustomerId
Join InvoiceLine IL 
    ON IL.InvoiceId = I.InvoiceId
GROUP BY C.FirstName, C.LastName, C.Country, C.CustomerId, I.InvoiceDate
)
SELECT
    FirstName
    ,LastName
    ,Country
    ,InvoiceDate
    ,Total
    ,SUM(Total) OVER (PARTITION BY CustomerId) AS TotalByCustomer
    ,SUM(Total) OVER (PARTITION BY Country) AS TotalByCountry
FROM CTE
ORDER BY Country, LastName, Total;


--9
WITH CTE AS 
(
SELECT
    AL.Title AS AlbumTitle
    ,AL.AlbumId
    ,T.Name AS TrackName
    ,T.Milliseconds
    ,T.TrackId
FROM Album AL 
JOIN Track T 
    ON T.AlbumId = AL.AlbumId
JOIN Artist A 
    ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'Green Day'
)
SELECT
    AlbumTitle
    ,CONVERT(varchar, DATEADD(ms, SUM(Milliseconds) OVER (PARTITION BY AlbumId), 0), 108) AS AlbumTime
    ,ROW_NUMBER() OVER (PARTITION BY AlbumId ORDER BY Milliseconds DESC) AS TrackNumber
    ,TrackName
    ,COUNT(TrackId) OVER (PARTITION BY AlbumId) AS TrackCount
    ,CONVERT(varchar, DATEADD(ms, Milliseconds, 0), 108) AS TrackTime
FROM CTE
ORDER BY AlbumTitle, TrackNumber;


--10
WITH CTE AS
(
SELECT
    BillingCountry
    ,YEAR(InvoiceDate) AS BillingYear
    ,SUM(Total) AS CurrentYear
FROM Invoice 
WHERE BillingCountry IN ('USA', 'Canada')
GROUP BY BillingCountry, YEAR(InvoiceDate)
)
SELECT
    BillingCountry
    ,BillingYear
    ,CurrentYear
    ,LAG(CurrentYear,1,0) OVER (PARTITION BY BillingCountry ORDER BY BillingYear) AS PriorYear
    ,CurrentYear - LAG(CurrentYear,1,0) OVER (PARTITION BY BillingCountry ORDER BY YEAR(BillingYear)) AS YearDifference
FROM CTE
ORDER BY BillingCountry;

