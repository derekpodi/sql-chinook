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

/*
SELECT *
FROM Track_v_dp
*/

GO

--2
CREATE FUNCTION ArtistAlbum_fn_dp (@TrackId int)
RETURNS varchar(100)
AS
BEGIN
DECLARE @ArtistAlbum varchar(100)
SELECT
    @ArtistAlbum = CONCAT(A.Name, '-', AL.Title)
FROM Track T
JOIN Album AL
    ON AL.AlbumId = T.AlbumId
JOIN Artist A
    ON A.ArtistId = AL.ArtistId
WHERE T.TrackId = @TrackId
RETURN
    @ArtistAlbum
END

/*
SELECT
    dbo.ArtistAlbum_fn_dp(TrackId)
FROM Track
*/

GO

--3     --STILL INCORRECT
CREATE PROC TracksByArtist_p_dp @ArtistName varchar(100) AS
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
FROM Artist A
JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
JOIN Track T
    ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%',@ArtistName,'%')


/*
EXEC TracksByArtist_p_dp 'Black'
*/

GO

--4
SELECT
    T.Name
    ,T.GenreName
    ,T.MediaTypeName
FROM Track_v_dp T
JOIN Album AL 
    ON AL.AlbumId = T.AlbumId
WHERE T.Name = 'Babylon'


GO

--5
SELECT
    dbo.ArtistAlbum_fn_dp(T.TrackId) AS [Artist and Album]
    ,T.Name AS TrackName
FROM Track_v_dp T
WHERE T.GenreName = 'Opera'


GO

--6     --STILL INCORRECT;--Problem Number 3 is incorrect -> get 54 rows, 0 rows as is currently
EXEC TracksByArtist_p_dp 'black'
GO
EXEC TracksByArtist_p_dp 'white'
GO


--7
ALTER PROC [dbo].[TracksByArtist_p_dp] 
    @ArtistName varchar(100) = 'Scorpions' AS
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,T.Name AS TrackName
FROM Artist A
JOIN Album AL 
    ON AL.ArtistId = A.ArtistId
JOIN Track T
    ON T.AlbumId = AL.AlbumId
WHERE A.Name LIKE CONCAT('%',@ArtistName,'%')


GO

--8
EXEC TracksByArtist_p_dp

GO

--9

DROP TABLE IF EXISTS  #Employee_Temp
GO

SELECT *
INTO #Employee_Temp
FROM Employee

BEGIN TRANSACTION
UPDATE #Employee_Temp
SET LastName = 'Podimatis'
WHERE EmployeeId = 1


--10
SELECT 
    EmployeeId
    ,LastName
FROM #Employee_Temp
WHERE EmployeeId =1

ROLLBACK TRANSACTION

SELECT 
    EmployeeId
    ,LastName
FROM #Employee_Temp
WHERE EmployeeId =1




