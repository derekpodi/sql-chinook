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
