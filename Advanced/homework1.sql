--Derek Podimatis

USE Chinook


--1
;WITH CTE AS 
(
SELECT
    T.Name AS TrackName
    ,AL.Title AS AlbumTitle
    ,A.Name AS ArtistName
    ,CONCAT('Track',ROW_NUMBER() OVER (PARTITION BY T.AlbumId ORDER BY T.TrackId)) AS TrackNumber
FROM Track T
JOIN Album AL ON AL.AlbumId = T.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
)
SELECT
    ArtistName
    ,AlbumTitle
    ,MAX(CASE WHEN TrackNumber = 'Track1' THEN TrackName END) AS Track1
    ,MAX(CASE WHEN TrackNumber = 'Track2' THEN TrackName END) AS Track2
    ,MAX(CASE WHEN TrackNumber = 'Track3' THEN TrackName END) AS Track3
FROM CTE 
GROUP BY ArtistName, AlbumTitle
ORDER BY ArtistName, AlbumTitle


--2
;WITH CTE AS 
(
SELECT
    T.Name AS TrackName
    ,AL.Title AS AlbumTitle
    ,A.Name AS ArtistName
    ,T.Milliseconds AS TrackLength
    ,CONCAT('Track',ROW_NUMBER() OVER (PARTITION BY T.AlbumId ORDER BY T.TrackId)) AS TrackNumber
FROM Track T
JOIN Album AL ON AL.AlbumId = T.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
)
SELECT
    ArtistName
    ,AlbumTitle
    ,MAX(CASE WHEN TrackNumber = 'Track1' THEN TrackName END) AS Track1
    ,MAX(CASE WHEN TrackNumber = 'Track1' THEN TrackLength END) AS TrackLength1
    ,MAX(CASE WHEN TrackNumber = 'Track2' THEN TrackName END) AS Track2
    ,MAX(CASE WHEN TrackNumber = 'Track2' THEN TrackLength END) AS TrackLength2
    ,MAX(CASE WHEN TrackNumber = 'Track3' THEN TrackName END) AS Track3
    ,MAX(CASE WHEN TrackNumber = 'Track3' THEN TrackLength END) AS TrackLength3
FROM CTE 
GROUP BY ArtistName, AlbumTitle
ORDER BY ArtistName, AlbumTitle


--3
;WITH CTE AS
(
SELECT
    T.Name AS TrackName
    ,AL.Title AS AlbumTitle
    ,A.Name AS ArtistName
    ,CONCAT('Track', ROW_NUMBER() OVER (PARTITION BY T.AlbumId ORDER BY T.TrackId)) AS TrackNumber
    ,COUNT(*) OVER (PARTITION BY T.AlbumId) AS TrackCount
FROM Track T
JOIN Album AL ON AL.AlbumId = T.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
)
SELECT
    ArtistName
    ,AlbumTitle
    ,TrackCount
    ,Track1 , Track2, Track3, Track4, Track5, Track6, Track7, Track8, Track9, Track10
    ,Track11, Track12, Track13, Track14, Track15, Track16, Track17, Track18, Track19, Track20
FROM CTE
PIVOT(
    MAX(TrackName)
    FOR TrackNumber IN (Track1 , Track2, Track3, Track4, Track5, Track6, Track7, Track8, Track9, Track10
    ,Track11, Track12, Track13, Track14, Track15, Track16, Track17, Track18, Track19, Track20)
) AS P
WHERE TrackCount >= 20
ORDER By TrackCount, ArtistName, AlbumTitle


--4
SELECT
    C.CustomerId
    ,C.LastName
    ,SUM(CASE WHEN YEAR(I.InvoiceDate) = 2009 THEN I.Total ELSE 0 END) AS Total2009
    ,SUM(CASE WHEN YEAR(I.InvoiceDate) = 2011 THEN I.Total ELSE 0 END) AS Total2011
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
WHERE YEAR(I.InvoiceDate) IN (2009, 2011)
GROUP BY C.CustomerId, C.LastName


--5
SELECT
    C.Country
    ,SUM(CASE WHEN YEAR(I.InvoiceDate) = 2011 THEN I.Total ELSE 0 END) AS Total2011
    ,SUM(CASE WHEN YEAR(I.InvoiceDate) = 2012 THEN I.Total ELSE 0 END) AS Total2012
    ,SUM(CASE WHEN YEAR(I.InvoiceDate) = 2013 THEN I.Total ELSE 0 END) AS Total2013
    ,COUNT(DISTINCT C.CustomerId) AS UniqueCustomers
    ,COUNT(I.InvoiceId) AS OrdersByCountry
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
WHERE YEAR(I.InvoiceDate) IN (2011, 2012, 2013)
GROUP BY C.Country


--6
SELECT
    EmployeeId, 'BirthDate' AS Field, CONVERT(nvarchar(50),BirthDate,101) AS Value
FROM Employee
UNION ALL 
SELECT
    EmployeeId, 'FirstName', FirstName
FROM Employee
UNION ALL
SELECT
    EmployeeId, 'LastName', LastName
FROM Employee
ORDER BY EmployeeId


--7
SELECT 
    E.EmployeeId, U.Field, U.Value
FROM Employee E 
CROSS APPLY 
    (VALUES
        ('BirthDate', CONVERT(nvarchar(50),BirthDate,101))
        ,('FirstName', E.FirstName)
        ,('LastName', E.LastName)
) U (Field, Value)


--8
SELECT 
    EmployeeId, Field, Value
FROM (
    SELECT
        EmployeeId
        ,CONVERT(nvarchar(50),BirthDate,101) AS BirthDate
        ,CAST(FirstName AS nvarchar(50)) AS FirstName
        ,Cast(LastName AS nvarchar(50)) AS LastName
    From Employee
    ) AS E
UNPIVOT
    (Value FOR Field IN(BirthDate, FirstName, LastName)) U


--9
;WITH CTE AS 
(
SELECT E.EmployeeId, U.Field, U.Value
FROM Employee E 
CROSS APPLY 
    (VALUES
        ('BirthDate', CONVERT(nvarchar(50),BirthDate,101))
        ,('FirstName', E.FirstName)
        ,('LastName', E.LastName)
) U (Field, Value) 
)
SELECT
    E.EmployeeId
    ,MAX(CASE WHEN E.Field = 'FirstName' THEN E.Value END) AS FirstName
    ,MAX(CASE WHEN E.Field = 'LastName' THEN E.Value END) AS LastName
    ,MAX(CASE WHEN E.Field = 'BirthDate' THEN E.Value END) AS BirthDate
FROM CTE E
GROUP BY E.EmployeeId


--10
;WITH CTE AS
(
SELECT
    C.LastName
    ,I.InvoiceDate
    ,A.Name
    ,ROW_NUMBER() OVER (PARTITION BY C.LastName, I.InvoiceDate ORDER BY I.InvoiceDate, A.Name) AS ArtistOrder
    ,CONCAT('Purchase',DENSE_RANK() OVER (PARTITION BY C.LastName ORDER BY I.InvoiceDate)) AS PurchaseOrder
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL ON IL.InvoiceId = I.InvoiceId
JOIN Track T ON T.TrackId = IL.TrackId
JOIN Album AL ON AL.AlbumId = T.AlbumId
JOIN Artist A ON A.ArtistId = AL.ArtistId
Where C.Country = 'India'
GROUP BY C.LastName, I.InvoiceDate, A.Name
)
SELECT
    LastName AS Customer
    ,ArtistOrder
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase1' THEN Name END),'') AS Purchase1
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase2' THEN Name END),'') AS Purchase2
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase3' THEN Name END),'') AS Purchase3
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase4' THEN Name END),'') AS Purchase4
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase5' THEN Name END),'') AS Purchase5
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase6' THEN Name END),'') AS Purchase6
    ,ISNULL(MAX(CASE WHEN PurchaseOrder = 'Purchase7' THEN Name END),'') AS Purchase7
FROM CTE 
GROUP BY LastName, ArtistOrder
ORDER By LastName
