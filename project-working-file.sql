--Derek Podimatis

Use Chinook

--1
SELECT TOP (10) WITH TIES
    A.Name AS [Artist Name]
    --,I.CustomerId
    --,IL.TrackId
    --,T.Name
    --,Al.AlbumId
    --,Al.Title
    --,I.Total AS [Total Sales]
    --,I.InvoiceDate
    --,I.InvoiceId
    ,COUNT(A.Name) * 0.99 AS [Total Sales]
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
GROUP BY A.Name
ORDER BY [Total Sales] DESC


-- HELPER SQL QUERIES --
SELECT *
FROM Track

SELECT *
FROM MediaType

SELECT *
FROM InvoiceLine

SELECT
    *
    --,MIN(I.InvoiceId)
    --,MAX(I.InvoiceId)
    --,SUM(I.Total)
FROM Invoice I
WHERE I.InvoiceDate BETWEEN '7/1/2011' AND '6/30/2012'

--83 invoices between the dates. 
--InvoiceId 209 - 291.
-- Total spent is 437.58 before video track deductions


SELECT *
FROM InvoiceLine IL
JOIN Invoice I
    ON I.InvoiceId = IL.InvoiceId
WHERE I.InvoiceDate BETWEEN '7/1/2011' AND '6/30/2012'

--442 InvoiceLineIds made between the dates



SELECT --TOP (10)
    A.Name AS [Artist Name]
    ,I.CustomerId
    ,IL.TrackId
    ,T.Name
    ,Al.AlbumId
    ,Al.Title
    ,I.Total AS [Total Sales]
    ,I.InvoiceDate
FROM Invoice I
JOIN InvoiceLine IL
    ON IL.InvoiceId = I.InvoiceId
JOIN Track T
    ON T.TrackId = IL.TrackId
JOIN Album Al
    ON Al.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = Al.ArtistId
WHERE I.InvoiceDate BETWEEN '7/1/2011' AND '6/30/2012'
    AND T.MediaTypeId != 3
ORDER BY I.Total DESC


-- #1 CLEAN WORKING ANSWER  -- 

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
    ,MONTH(I.InvoiceDate) AS [Sales Quarter]
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
ORDER BY [Employee Name],[Calendar Year], [Sales Quarter]



-- HELPER QUERIES --

--Implement Month Buckets with Names --
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Employee Name]
    ,YEAR(I.InvoiceDate) AS [Calendar Year]
    ,CASE 
        WHEN MONTH(I.InvoiceDate) <= 3
            THEN 'First'
        WHEN MONTH(I.InvoiceDate) >= 4 AND MONTH(I.InvoiceDate) < 7
            THEN 'Second'
        WHEN MONTH(I.InvoiceDate) >= 7 AND MONTH(I.InvoiceDate) < 10
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
GROUP BY I.InvoiceDate, E.FirstName, E.LastName
ORDER BY [Employee Name],[Calendar Year], MONTH(I.InvoiceDate)



--Flip Joins Test query - Start at Invoice table
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Employee Name]
    ,YEAR(I.InvoiceDate) AS [Calendar Year]
    ,CASE 
        WHEN MONTH(I.InvoiceDate) <= 3
            THEN 'First'
        WHEN MONTH(I.InvoiceDate) >= 4 AND MONTH(I.InvoiceDate) < 7
            THEN 'Second'
        WHEN MONTH(I.InvoiceDate) >= 7 AND MONTH(I.InvoiceDate) < 10
            THEN 'Third'
        ELSE
            'Fourth'
    END AS [Sales Quarter]
FROM Invoice I
JOIN Customer C
    ON C.CustomerId = I.CustomerId
JOIN Employee E
    ON E.EmployeeId = C.SupportRepId
WHERE E.Title = 'Sales Support Agent'
    AND I.InvoiceDate BETWEEN '1/1/2010' AND '6/30/2012'
GROUP BY YEAR(I.InvoiceDate),MONTH(I.InvoiceDate), E.FirstName, E.LastName
ORDER BY [Employee Name], [Calendar Year], [Sales Quarter]




-- NOT FINISHED/CORRRECT ... YET --
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS [Employee Name]
    ,YEAR(I.InvoiceDate) AS [Calendar Year]
    ,DATENAME(QUARTER, I.InvoiceDate) AS [Sales Quarter]
    ,MAX(I.Total)
FROM Employee E
JOIN Customer C
    ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
WHERE E.Title = 'Sales Support Agent'
    AND I.InvoiceDate BETWEEN '1/1/2010' AND '6/30/2012'
GROUP BY E.LastName, E.FirstName, I.InvoiceDate
ORDER BY [Employee Name], [Calendar Year], [Sales Quarter]



-- Cleaner Quarter Cases
-- #2 CLEAN WORKING ANSWER  -- 
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
SELECT *
FROM Playlist

SELECT *
FROM PlaylistTrack

-- Playlist ID and Name with no TrackIDs --
SELECT * --DISTINCT 
    --P.Name
    --P.PlaylistId
    --PT.TrackId
FROM Playlist P
--JOIN PlaylistTrack PT
--    ON PT.PlaylistId = P.PlaylistId
WHERE P.PlaylistId NOT IN (
    SELECT 
        PT.PlaylistId
    FROM PlaylistTrack PT
)

-- Duplicate Playlists 
SELECT
    P.Name
    ,COUNT(P.Name) AS Duplicates
FROM Playlist P
GROUP BY Name
ORDER BY Name


--  Write a report that displays the duplicate Playlist IDs and Playlist Names, as well as any associated Track IDs if they exist. 
-- #3 CLEAN WORKING ANSWER  -- 
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
--Incorrect count difference, add group by correctly
SELECT
    C.Country AS Country
    ,A.Name AS [Artist Name]
    ,COUNT(IL.TrackId) AS [Track Count]
    ,COUNT(DISTINCT IL.TrackId) AS [Unique Track Count]
    ,COUNT(IL.TrackId) - COUNT(DISTINCT IL.TrackId) AS [Count Difference]
    ,T.UnitPrice * COUNT(*) AS [Total Revenue]
    ,IIF(M.MediaTypeId =3, 'Video', 'Audio') AS [Media Type]
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
    ON IL.InvoiceId = I.InvoiceId
JOIN Track T
    ON T.TrackId = IL.TrackId
JOIN MediaType M 
    ON M.MediaTypeId = T.MediaTypeId
JOIN Album AL
    ON AL.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = AL.ArtistId
WHERE I.InvoiceDate BETWEEN '7/1/2009' AND '6/30/2013'
    --AND C.Country = 'USA'   --Count Check
GROUP BY C.Country, A.Name, M.MediaTypeId, T.UnitPrice
HAVING COUNT(IL.Quantity) - COUNT(DISTINCT IL.TrackId) > 0
ORDER BY C.Country, [Track Count] DESC, A.Name


SELECT *
FROM InvoiceLine

SELECT *
FROM Invoice



--#4 Correct Working Version
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