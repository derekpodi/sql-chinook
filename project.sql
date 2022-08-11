--Derek Podimatis

Use Chinook

--1
SELECT TOP (10) WITH TIES
    A.Name AS [Artist Name]
    ,COUNT(A.Name) * T.UnitPrice AS [Total Sales]
FROM Artist A
JOIN Album Al
    ON Al.ArtistId = A.ArtistId
JOIN Track T
    ON T.AlbumId = Al.AlbumId
JOIN InvoiceLine IL
    ON IL.TrackId = T.TrackId
JOIN Invoice I
    ON I.InvoiceId = IL.InvoiceId
WHERE I.InvoiceDate BETWEEN '7/1/2011' AND '6/30/2012'
    AND T.MediaTypeId != 3
GROUP BY A.Name, T.UnitPrice
ORDER BY [Total Sales] DESC



--2 
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Employee Name]
    ,YEAR(I.InvoiceDate) AS [Calendar Year]
    ,CASE 
        WHEN DATENAME(quarter,I.InvoiceDate) = 1
            THEN 'First'
        WHEN DATENAME(quarter,I.InvoiceDate) = 2            
            THEN 'Second'
        WHEN DATENAME(quarter,I.InvoiceDate) = 3
            THEN 'Third'
        ELSE
            'Fourth'
    END AS [Sales Quarter]
    ,MAX(I.Total) AS [Highest Sale]
    ,COUNT(C.SupportRepId) AS [Number of Sales]
    ,SUM(I.Total) AS [Total Sales]
FROM Employee E
JOIN Customer C
    ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
WHERE E.Title = 'Sales Support Agent'
    AND I.InvoiceDate BETWEEN '1/1/2010' AND '6/30/2012'
GROUP BY YEAR(I.InvoiceDate), DATENAME(quarter,I.InvoiceDate), E.FirstName, E.LastName
ORDER BY [Employee Name], [Calendar Year], DATENAME(quarter,I.InvoiceDate)



--3
SELECT
    P.Name AS [Playlist Name]
    ,P.PlaylistId AS [Playlist ID]
    ,PT.TrackId AS [Track ID]
FROM Playlist P
LEFT JOIN PlaylistTrack PT
    ON PT.PlaylistId = P.PlaylistId
WHERE P.Name IN (
    SELECT P.Name
    FROM Playlist P
    GROUP BY P.Name
    HAVING COUNT(P.Name) > 1
) AND P.PlaylistId > 5                          --first duplicate in playlist at id 6
GROUP BY P.Name, P.PlaylistId, PT.TrackId
ORDER BY P.PlaylistId, PT.TrackId



--4
SELECT 
    C.Country AS Country
    ,A.Name AS [Artist Name]
    ,COUNT(T.Name) AS [Track Count]
    ,COUNT(DISTINCT T.Name) AS [Unique Track Count]
    ,COUNT(T.Name) - COUNT(DISTINCT T.Name) AS [Count Difference]
    ,T.UnitPrice * COUNT(*) AS [Total Revenue]
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
GROUP BY C.Country, A.Name, T.UnitPrice, IIF(T.MediaTypeId =3, 'Video', 'Audio')
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