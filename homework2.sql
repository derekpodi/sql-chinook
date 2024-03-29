--Derek Podimatis

USE Chinook

--1
SELECT
    FirstName
    ,LastName
FROM Employee
WHERE ReportsTo IS NOT NULL


--2
SELECT *
FROM Customer
WHERE State != 'CA'
    OR State IS NULL


--3
SELECT *
FROM Invoice
WHERE InvoiceDate BETWEEN '4/1/2010' AND '5/1/2010'


--4
SELECT
    Title
    ,AlbumId
FROM Album
WHERE Title LIKE 'The%'


--5
SELECT *
FROM Album
WHERE Title NOT LIKE '[A-Z]%'


--6
SELECT
    CustomerId
    ,BillingCity
    ,BillingCountry
    ,InvoiceDate
FROM Invoice
WHERE BillingCountry IN ('Canada', 'Germany', 'France', 'Spain', 'India')
ORDER BY InvoiceDate DESC


--7
SELECT *
FROM ALBUM
WHERE ArtistId IN(
    SELECT ArtistId
    FROM Artist
    WHERE Name LIKE '%Black%')


--8
SELECT *
FROM Track
WHERE TrackId NOT IN(
    SELECT TrackId
    FROM InvoiceLine
)


--9
SELECT *
FROM Track
WHERE (MediaTypeId = 5 AND GenreId != 1)
    OR Composer = 'Gene Simmons'


--10
SELECT *
FROM Track
WHERE AlbumId = 237 
    AND (Composer LIKE '%Dylan%' OR Composer LIKE '%Hendrix%')
    
