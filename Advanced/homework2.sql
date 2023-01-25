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
    ORDER BY T.TrackId
) CA
WHERE A.Name = 'Queen'
ORDER BY AL.Title, CA.TrackId


--4
;WITH CTE AS (
    SELECT TOP 5
        AL.Title
        ,A.Name
        ,AL.AlbumId
    FROM Album AL
    JOIN Artist A ON A.ArtistId = AL.ArtistId
    WHERE A.Name = 'U2'
    ORDER BY AL.Title DESC
)
SELECT 
    CTE.Name AS ArtistName
    ,CTE.Title AS AlbumTitle
    ,CA.Name AS TrackName
FROM CTE
CROSS APPLY (
    SELECT TOP 3 * FROM Track T
    WHERE T.AlbumId = CTE.AlbumId
    ORDER BY T.Name DESC
) CA
ORDER BY CTE.Title DESC


--5
SELECT
    E.FirstName AS SupportRep
    ,CA.Country
    ,CA.Total
FROM Employee E
CROSS APPLY(
    SELECT TOP 4
        C.Country
        ,SUM(I.Total) AS Total
    FROM Customer C
    JOIN Invoice I ON I.CustomerId = C.CustomerId
    WHERE C.SupportRepId = E.EmployeeId
    GROUP BY C.Country
    ORDER BY Total DESC
) CA


--6
SELECT
    C.CustomerId
    ,CA.Description
    ,CA.Value
FROM Customer C
JOIN Employee E ON E.EmployeeId = C.SupportRepId
CROSS APPLY(
    VALUES
    ('CustomerName',CONCAT(C.FirstName,' ',C.LastName))
    ,('Location',CONCAT(C.City,', ',C.Country))
    ,('SupportRep', E.FirstName)
    ,('SupportRepEmail', E.Email) 
) CA(Description, Value)
WHERE C.Country IN ('Denmark', 'Chile')


--7
SELECT
    A.ArtistId
    ,AL.AlbumId
    ,A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
    ,CA.Search
FROM Artist A
JOIN Album AL ON A.ArtistId = AL.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
CROSS APPLY(
    VALUES (AL.Title), (T.Name)
) AS CA(Search)
WHERE Search LIKE '%pill%'


--8
;WITH CTE AS
(
SELECT
    A.Name AS Artist
    ,AL.Title AS Album
    ,T.Name AS Track
    ,CONCAT('T', ROW_NUMBER() OVER (PARTITION BY AL.AlbumId ORDER BY T.TrackId)) AS TrackNumber
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
)
, TrackPivot AS
(
SELECT Artist, Album, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
FROM CTE
PIVOT (
    MAX(Track)
    FOR TrackNumber IN (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)
    ) P
)
SELECT
    Search
    ,T.*
FROM TrackPivot T
CROSS APPLY(
    VALUES
    (Artist), (Album), (T1), (T2), (T3), (T4), (T5), (T6), (T7), (T8), (T9), (T10)
) CA(Search)
WHERE Search LIKE '%green%'


--9
;WITH CTE AS
(
SELECT
    A.Name AS Artist
    ,AL.Title AS Album
    ,T.Name AS Track
    ,CONCAT('T', ROW_NUMBER() OVER (PARTITION BY AL.AlbumId ORDER BY T.TrackId)) AS TrackNumber
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
JOIN Track T ON T.AlbumId = AL.AlbumId
)
, TrackPivot AS
(
SELECT Artist, Album, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
FROM CTE
PIVOT (
    MAX(Track)
    FOR TrackNumber IN (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)
    ) P
)
SELECT
    Search
    ,ColumnName
    ,T.*
FROM TrackPivot T
CROSS APPLY(
    VALUES
    (Artist, 'Artist')
    , (Album, 'Album')
    , (T1, 'T1'), (T2, 'T2'), (T3, 'T3'), (T4, 'T4'), (T5, 'T5')
    , (T6, 'T6'), (T7, 'T7'), (T8, 'T8'), (T9, 'T9'), (T10, 'T10')
) CA(Search, ColumnName)
WHERE Search LIKE '%green%'


--10
GO
CREATE OR ALTER FUNCTION Album_tf (@AlbumId int)
RETURNS TABLE
AS 
RETURN 
SELECT 
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle 
FROM Artist A
JOIN Album AL ON AL.ArtistId = A.ArtistId
WHERE AL.AlbumId = @AlbumId
GO

SELECT
    CA.*
    ,T.Name AS TrackName
    ,T.Composer
FROM Track T
CROSS APPLY(
    SELECT * FROM Album_tf(AlbumId)
) CA
WHERE T.Composer LIKE '%Jackson%'

