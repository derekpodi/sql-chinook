--Derek Podimatis

USE Chinook

--1
SELECT *
FROM Employee


--2
SELECT 
    FirstName
    ,LastName
    ,Email
From Employee


--3
SELECT 
    Name
    ,Composer
    ,AlbumId
From Track
WHERE AlbumId = 19


--4
SELECT
    Name AS [Track Title]
    ,Composer
    ,AlbumId
FROM Track
WHERE AlbumId = 19
ORDER BY Composer, Name


--5
SELECT TOP(5)
    BillingCountry 
    ,BillingCity
    ,Total
FROM Invoice
WHERE BillingCountry != 'USA'
ORDER BY Total DESC


--6
SELECT DISTINCT
    State
    ,Country
FROM Customer
WHERE Country = 'USA'


--7
SELECT
    CustomerId
    ,BillingCity
    ,BillingPostalCode
    ,Total
FROM Invoice
Where BillingCountry = 'Germany' 
    AND Total > 5
ORDER BY CustomerId, Total DESC


--8
SELECT DISTINCT TOP(20)
    Country AS [Country Name]
    ,State AS [State or Region]
FROM Customer
ORDER BY Country,State


--9
SELECT
    AlbumId
    ,MediaTypeId
    ,Name
FROM Track
WHERE AlbumId <= 5 
    OR MediaTypeId = 2
ORDER BY AlbumId


--10
SELECT
    AlbumId
    ,Name
    ,Milliseconds
    ,UnitPrice
FROM Track
WHERE (AlbumId = 5 AND Milliseconds > 300000) 
    OR UnitPrice > 0.99
ORDER BY AlbumId, Milliseconds



