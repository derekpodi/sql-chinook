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
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,(
        SELECT COUNT(*)
        FROM Track T
        WHERE T.AlbumId = AL.AlbumId
    ) AS TrackCount
FROM Artist A
JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
WHERE A.Name = 'Iron Maiden'
ORDER BY TrackCount


--5
WITH TCount AS 
(
SELECT 
    T.AlbumId
    ,COUNT(*) AS TC
FROM Track T
JOIN Album AL 
    ON AL.AlbumId = T.AlbumId
WHERE T.AlbumId = AL.AlbumId
GROUP BY T.AlbumId
)
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,TC AS TrackCount
FROM TCount
JOIN Album AL
    ON AL.AlbumId = TCount.AlbumId
JOIN Artist A 
    ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'U2'
ORDER BY TrackCount


--6
WITH BD AS
(
SELECT
    E.BirthDate
    ,CONVERT(VARCHAR, DATEFROMPARTS(2021,MONTH(E.BirthDate),DAY(E.BirthDate)), 110 ) AS BirthDay2021
FROM Employee E
)
, CD AS
(
SELECT
    E.BirthDate
    ,CASE
        WHEN DATENAME(WEEKDAY, BD.BirthDay2021) = 'Saturday' THEN CONVERT(VARCHAR, DATEADD(day, 2, BD.BirthDay2021), 110)
        WHEN DATENAME(WEEKDAY, BD.BirthDay2021) = 'Sunday' THEN CONVERT(VARCHAR, DATEADD(day, 1, BD.BirthDay2021), 110)
        ELSE BD.BirthDay2021 
        END AS CelebrationDate
FROM Employee E
JOIN BD 
    ON BD.BirthDate = E.BirthDate
)
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS FullName
    ,CONVERT(VARCHAR, E.BirthDate, 110) AS BirthDate
    ,BD.BirthDay2021
    ,DATENAME(WEEKDAY, BD.BirthDay2021) AS BirthDayOfWeek2021
    ,CD.CelebrationDate
    ,DATENAME(WEEKDAY, CD.CelebrationDate) AS CelebrationDayOfWeek
FROM Employee E
JOIN BD
    ON BD.BirthDate = E.BirthDate
JOIN CD 
    ON CD.BirthDate = E.BirthDate


--7
