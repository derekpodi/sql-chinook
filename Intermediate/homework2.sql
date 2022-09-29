--Derek Podimatis

USE Chinook
IF OBJECT_ID('Track_v_edw') IS NOT NULL DROP VIEW Track_v_dp
IF OBJECT_ID('ArtistAlbum_fn_edw') IS NOT NULL DROP FUNCTION ArtistAlbum_fn_dp
IF OBJECT_ID('TracksByArtist_p_edw') IS NOT NULL DROP PROC TracksByArtist_p_dp


--1
