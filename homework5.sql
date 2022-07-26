--Derek Podimatis

USE Chinook

--1
SELECT 
    T.Name AS TrackName
    ,MT.Name AS MediaName
    ,CASE 
        WHEN MT.MediaTypeId = 3 THEN 'Video'
        ELSE 'Audio'
        END AS MediaType
    ,CASE
        WHEN MT.Name Like '%AAC%' THEN 'AAC'
        WHEN MT.Name Like '%MPEG%' THEN 'MPEG'
        ELSE 'Unknown'
        END AS EncodingFormat
FROM Track T
JOIN MediaType MT
    ON MT.MediaTypeId = T.MediaTypeId


--2
SELECT
    MT.Name AS MediaTypeName
    ,COUNT(MT.MediaTypeId) AS TotalTracks
FROM MediaType MT   
JOIN Track T
    ON T.MediaTypeId = MT.MediaTypeId
GROUP BY MT.Name


--3
SELECT
    E.FirstName
    ,E.LastName
    ,YEAR(I.InvoiceDate) AS SaleYear
    ,SUM(I.Total) AS TotalSales
FROM Employee E
JOIN Customer C
    ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
GROUP BY E.FirstName, E.LastName, YEAR(I.InvoiceDate)
--ORDER BY E.FirstName, YEAR(I.InvoiceDate)


--4
SELECT
    C.LastName
    ,C.FirstName
    ,MAX(I.Total) AS MaxInvoice
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
    ON IL.InvoiceId = I.InvoiceId
GROUP BY C.FirstName, C.LastName
--ORDER BY C.LastName DESC


--5
SELECT
    C.Country
    ,C.PostalCode
    ,CASE
        WHEN C.PostalCode IS NULL THEN 'Unknown'
        WHEN ISNUMERIC(C.PostalCode) = 1 THEN 'Yes'
        WHEN ISNUMERIC(C.PostalCode) = 0 THEN 'No'
        END AS NumericPostalCode
FROM Customer C
ORDER BY NumericPostalCode, C.Country


--6
SELECT
    C.FirstName
    ,C.LastName
    ,SUM(I.Total) AS TotalSales
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
GROUP BY C.FirstName, C.LastName
HAVING SUM(I.Total) > 42.
--ORDER BY TotalSales DESC


--7
SELECT TOP 1
    A.Name AS TopArtist
    --,COUNT(T.TrackId) TrackCount
FROM Artist A
JOIN Album AL
    ON AL.ArtistId = A.ArtistId
JOIN Track T
    ON T.AlbumId = AL.AlbumId
GROUP BY A.Name
ORDER BY COUNT(T.TrackId) DESC


--8
SELECT
    C.FirstName
    ,C.LastName
    ,CASE
        WHEN C.LastName LIKE '[A-G]%' THEN 'Group1'
        WHEN C.LastName LIKE '[H-M]%' THEN 'Group2'
        WHEN C.LastName LIKE '[N-S]%' THEN 'Group3'
        WHEN C.LastName LIKE '[T-Z]%' THEN 'Group4'
        ELSE NULL
    END AS CustomerGrouping
FROM Customer C
--ORDER BY C.LastName, CustomerGrouping


--9
SELECT
    A.Name AS ArtistName
    ,COUNT(AL.AlbumId) AS AlbumCount
FROM Artist A
LEFT JOIN Album AL
    ON AL.ArtistId = A.ArtistId
GROUP BY A.Name
ORDER BY AlbumCount, ArtistName


--10
SELECT
    E.FirstName
    ,E.LastName
    ,E.Title
    ,CASE
        WHEN E.Title LIKE '%Manager%' THEN 'Management'
        WHEN E.Title LIKE '%Sales%' THEN 'Sales'
        WHEN E.Title LIKE '%IT%' THEN 'Technology'
    END AS Department
FROM Employee E
ORDER BY Department

