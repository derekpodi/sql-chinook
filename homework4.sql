--Derek Podimatis

USE Chinook

--1
SELECT
    A.Name AS ArtistName
    ,Al.Title AS AlbumTitle
FROM Artist A
JOIN Album Al
    ON Al.ArtistId = A.ArtistId
WHERE A.Name LIKE '[A-D]%'

ORDER BY ArtistName, AlbumTitle 


--2
SELECT
    A.Name AS ArtistName
    ,Al.Title AS AlbumTitle
FROM Artist A
LEFT JOIN Album Al
    ON Al.ArtistId = A.ArtistId
WHERE A.Name LIKE '[A-D]%'
ORDER BY ArtistName, AlbumTitle 


--3
SELECT
    A.Name AS ArtistName
    ,T.Name AS TrackName
FROM Track T
JOIN Album Al
    ON Al.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = Al.ArtistId
Join Genre G
    ON G.GenreId = T.GenreId
WHERE G.Name = 'Alternative'
ORDER BY ArtistName, TrackName


--4
SELECT
    E.FirstName
    ,C.LastName
FROM Employee E
CROSS JOIN Employee C
--ORDER BY FirstName


--5
SELECT 
    P.Name AS PlaylistName
    ,A.Name AS ArtistName
    ,Al.Title AS AlbumName
    ,T.Name AS TrackName
    ,G.Name AS GenreName
FROM Playlist P
JOIN PlaylistTrack PT
    ON PT.PlaylistId = P.PlaylistId
JOIN Track T
    ON PT.TrackId = T.TrackId
JOIN Genre G
    ON G.GenreId = T.GenreId
JOIN Album Al
    ON Al.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = Al.ArtistId
WHERE P.Name = 'Grunge'


--6
SELECT 
    A.Title 
    ,T.Name 
    ,T.Milliseconds/1000 AS Seconds
FROM Album A
JOIN Track T
    ON T.AlbumId = A.AlbumId
WHERE A.Title = 'Let There Be Rock'


--7
SELECT 
    CONCAT(E.FirstName,' ', E.LastName) AS CustomerRep
    ,CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName
    ,C.Country
FROM Employee E
JOIN Customer C
    ON C.SupportRepId = E.EmployeeId
ORDER BY CustomerRep, C.Country


--8
SELECT
    A.Title
    ,T.Name
    ,I.InvoiceId
FROM Album A
JOIN Track T
    ON T.AlbumId = A.AlbumId
LEFT JOIN InvoiceLine I
    ON I.TrackId = T.TrackId
ORDER BY T.Name DESC, I.InvoiceId DESC


--9
SELECT
    E.EmployeeId
    ,E.LastName
    ,E.FirstName
    ,E.ReportsTo
    ,IIF(E.ReportsTo IS NULL,'N/A', CONCAT(C.FirstName, ' ', C.LastName)) AS ManagerName
FROM Employee E
LEFT JOIN Employee C
    ON C.EmployeeId = E.ReportsTo


--10
SELECT
    C.LastName
    ,A.Title
    ,T.Name
    ,CONVERT(varchar,I.InvoiceDate,103) AS PurchaseDate   --dd/mm/yyyy varchar
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
    ON IL.InvoiceId = I.InvoiceId
JOIN Track T
    ON T.TrackId = IL.TrackId
JOIN Album A
    ON A.AlbumId = T.AlbumId
WHERE C.LastName = 'Barnett' AND C.FirstName = 'Julia'
ORDER BY I.InvoiceDate, A.Title, T.Name

