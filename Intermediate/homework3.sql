--Derek Podimatis


--1
WITH AA AS
(
SELECT
    A.ArtistId
    ,A.NAME AS ArtistName
    ,AL.AlbumId
    ,AL.Title AS AlbumTitle
FROM Artist A
JOIN ALBUM AL
    ON AL.ArtistId = A.ArtistId
WHERE A.NAME = 'AudioSlave'
)
SELECT
    ArtistName
    ,AlbumTitle
    ,T.Name AS TrackName
FROM AA
JOIN Track T
    ON T.AlbumId = AA.AlbumId


--2
SELECT
    ArtistName
    ,AlbumTitle
    ,T.Name AS TrackName
FROM
(
    SELECT
        A.ArtistId
        ,A.NAME AS ArtistName
        ,AL.AlbumId
        ,AL.Title AS AlbumTitle
    FROM Artist A
    JOIN ALBUM AL
        ON AL.ArtistId = A.ArtistId
    WHERE A.NAME = 'Kiss'
) AS AA
JOIN Track T
    ON T.AlbumId = AA.AlbumId


--3
WITH CustomerInvoice AS
(
SELECT
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName
    ,SUM(I.Total) AS SumTotal
    ,C.SupportRepId
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
GROUP BY C.FirstName, C.LastName, C.SupportRepId
)
SELECT
    E.LastName AS SupportRep
    ,CustomerName
    ,SumTotal
FROM CustomerInvoice
JOIN Employee E
    ON E.EmployeeId = CustomerInvoice.SupportRepId
ORDER BY SumTotal DESC, SupportRep


--4




