--Derek Podimatis

Use Chinook

--1
SELECT TOP (10) WITH TIES
    A.Name AS [Artist Name]
    ,SUM(IL.UnitPrice * IL.Quantity) AS [Total Sales]
FROM Artist A
JOIN Album Al
    ON Al.ArtistId = A.ArtistId
JOIN Track T
    ON T.AlbumId = Al.AlbumId
JOIN InvoiceLine IL
    ON IL.TrackId = T.TrackId
JOIN Invoice I
    ON I.InvoiceId = IL.InvoiceId
WHERE (I.InvoiceDate BETWEEN '7/1/2011' AND '6/30/2012')
    AND T.MediaTypeId != 3
GROUP BY A.Name
ORDER BY [Total Sales] DESC



--2 
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Employee Name]
    ,YEAR(I.InvoiceDate) AS [Calendar Year]
    ,CASE DATEPART(QUARTER, I.InvoiceDate)
        WHEN 1 THEN 'First'
        WHEN 2 THEN 'Second'
        WHEN 3 THEN 'Third'
        WHEN 4 THEN 'Fourth'
        END AS [Sales Quarter]
    ,MAX(I.Total) AS [Highest Sale]
    ,COUNT(I.Total) AS [Number of Sales]
    ,SUM(I.Total) AS [Total Sales]
FROM Employee E
JOIN Customer C
    ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
WHERE I.InvoiceDate BETWEEN '1/1/2010' AND '6/30/2012'
GROUP BY E.FirstName, E.LastName, YEAR(I.InvoiceDate), DATEPART(QUARTER, I.InvoiceDate)
ORDER BY [Employee Name], [Calendar Year], DATEPART(QUARTER, I.InvoiceDate)



--3
SELECT
    P.Name AS [Playlist Name]
    ,P.PlaylistId AS [Playlist ID]
    ,PT.TrackId AS [Track ID]
FROM Playlist P
LEFT JOIN PlaylistTrack PT                      --Include Nulls
    ON PT.PlaylistId = P.PlaylistId
WHERE EXISTS(
    SELECT *
    FROM Playlist P2
    GROUP BY P2.Name
    HAVING COUNT(*) > 1                         --Duplicates
    AND MAX(P2.PlaylistId) = P.PlaylistId       --Higher duplicate PlaylistIds 
) 




--4
SELECT 
    C.Country AS Country
    ,A.Name AS [Artist Name]
    ,COUNT(T.Name) AS [Track Count]
    ,COUNT(DISTINCT T.Name) AS [Unique Track Count]
    ,COUNT(T.Name) - COUNT(DISTINCT T.Name) AS [Count Difference]
    ,SUM(IL.UnitPrice * IL.Quantity) AS [Total Revenue]
    ,IIF(T.MediaTypeId =3, 'Video', 'Audio') AS [Media Type]
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
    ON IL.InvoiceId = I.InvoiceId
JOIN Track T
    ON T.TrackId = IL.TrackId
JOIN Album AL
    ON AL.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = AL.ArtistId
WHERE I.InvoiceDate BETWEEN '7/1/2009' AND '6/30/2013'
GROUP BY C.Country, A.Name, IIF(T.MediaTypeId =3, 'Video', 'Audio')
ORDER BY C.Country, [Track Count] DESC, A.Name



--5
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Full Name]
    ,CONVERT(varchar, E.BirthDate, 101) AS [Birth Date]
    ,CONVERT(varchar, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date), 101) AS [Birth Day 2016]
    ,DATENAME(WEEKDAY, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)) AS [Birth Day of Week]
    ,CASE
        WHEN DATENAME(WEEKDAY, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)) = 'Saturday' 
            THEN CONVERT(varchar, DATEADD(DAY, 2, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)), 101)
        WHEN DATENAME(WEEKDAY, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)) = 'Sunday' 
            THEN CONVERT(varchar, DATEADD(DAY, 1, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)), 101)
        ELSE CONVERT(varchar, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date), 101)
        END AS [Celebration Date]
    ,CASE
        WHEN DATENAME(WEEKDAY, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)) = 'Saturday' 
            THEN DATENAME(WEEKDAY, CONVERT(varchar, DATEADD(DAY, 2, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)), 101))
        WHEN DATENAME(WEEKDAY, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)) = 'Sunday' 
            THEN DATENAME(WEEKDAY, CONVERT(varchar, DATEADD(DAY, 1, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date)), 101))
        ELSE DATENAME(WEEKDAY, CONVERT(varchar, CAST(CONCAT(MONTH(E.BirthDate),'/',DAY(E.BirthDate),'/','2016') AS date), 101))
        END AS [Celebration Day of Week]
FROM Employee E
