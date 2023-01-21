--Derek Podimatis

USE Chinook


--1
SELECT
    A.Name AS ArtistName
    ,CA.Title AS AlbumTitle
FROM Artist A
CROSS APPLY (
    SELECT * FROM Album AL
    WHERE AL.ArtistId = A.ArtistId
) CA


--2
SELECT
    A.Name AS ArtistName
    ,CA.Title AS AlbumTitle
FROM Artist A
OUTER APPLY (
    SELECT * FROM Album AL
    WHERE AL.ArtistId = A.ArtistId
) CA


--3
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,CA.Name AS TrackName
    ,CA.TrackId
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
CROSS APPLY (
    SELECT TOP 3 * FROM Track T
    WHERE T.AlbumId = AL.AlbumId
) CA
WHERE A.Name = 'Queen'
ORDER BY AL.Title, CA.TrackId


--4
SELECT TOP 15
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,CA.Name AS TrackName
FROM Artist A 
JOIN Album AL ON AL.ArtistId = A.ArtistId
CROSS APPLY (
    SELECT TOP 3 * FROM Track T
    WHERE T.AlbumId = AL.AlbumId
    ORDER BY T.Name DESC
) CA
WHERE A.Name = 'U2'
ORDER BY AL.Title DESC


--5
SELECT
    E.FirstName AS SupportRep
    ,CA.Country
    ,SUM(CA.Total) OVER (Partition BY CA.Country) AS Total
FROM Employee E
CROSS APPLY (
    SELECT TOP 4 
        C.*
        ,I.Total
    FROM Customer C
    JOIN INVOICE I ON I.CustomerId = C.CustomerId
    WHERE C.SupportRepId = E.EmployeeId
    ) CA
ORDER BY E.FirstName, CA.Country 



