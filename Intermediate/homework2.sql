--Derek Podimatis

USE Chinook
IF OBJECT_ID('Track_v_dp') IS NOT NULL DROP VIEW Track_v_dp
IF OBJECT_ID('ArtistAlbum_fn_dp') IS NOT NULL DROP FUNCTION ArtistAlbum_fn_dp
IF OBJECT_ID('TracksByArtist_p_dp') IS NOT NULL DROP PROC TracksByArtist_p_dp

GO

--1
CREATE VIEW Track_v_dp AS
SELECT
    T.*
    ,G.Name AS GenreName
    ,MT.Name AS MediaTypeName
FROM Track T
JOIN Genre G
    ON G.GenreId = T.GenreId
JOIN MediaType MT
    ON MT.MediaTypeId = T.MediaTypeId

GO


--2
GO
CREATE FUNCTION ArtistAlbum_fn_dp (@TrackId int)
RETURNS varchar(100)
AS
BEGIN
DECLARE @ArtistAlbum varchar(100)
SELECT
    @ArtistAlbum = CONCAT(A.Name, ' - ', AL.Title)
FROM Artist A
JOIN Album AL
       ON AL.ArtistId = A.ArtistId
JOIN Track T
       ON T.AlbumId = AL.AlbumId
WHERE T.TrackId = @TrackId
RETURN 
    @ArtistAlbum
END

GO


--3
GO
CREATE PROC TracksByArtist_p_dp @ArtistName varchar(100) AS
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
FROM Artist A
LEFT JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
LEFT JOIN Track T
    ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%',@ArtistName,'%')

GO


--4
SELECT
    AL.Title
    ,TV.Name
    ,TV.GenreName
    ,TV.MediaTypeName
FROM Track_v_dp TV
JOIN Album AL 
    ON AL.AlbumId = TV.AlbumId
WHERE TV.Name = 'Babylon'


--5
SELECT
    dbo.ArtistAlbum_fn_dp(TrackId) AS [Artist and Album]
    ,Name AS TrackName
FROM Track_v_dp 
WHERE GenreName = 'Opera'


--6
EXEC TracksByArtist_p_dp 'black'
EXEC TracksByArtist_p_dp 'white'


--7
GO
ALTER PROC TracksByArtist_p_dp 
    @ArtistName varchar(100) = 'Scorpions' AS
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
FROM Artist A
LEFT JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
LEFT JOIN Track T
    ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%',@ArtistName,'%')

GO

--8
EXEC TracksByArtist_p_dp


--9
BEGIN TRANSACTION
UPDATE Employee
SET LastName = 'Podimatis'
WHERE EmployeeId = 1


--10
SELECT 
    EmployeeId
    ,LastName
FROM Employee
WHERE EmployeeId =1

ROLLBACK TRANSACTION

SELECT 
    EmployeeId
    ,LastName
FROM Employee
WHERE EmployeeId =1


