--Derek Podimatis

USE Chinook


--1
DECLARE @Country AS nvarchar(50)
SET @Country = 'Canada'
SELECT @Country AS Country
GO


--2
DECLARE @Country AS nvarchar(50)
SET @Country = 'Canada'
SELECT @Country AS Country1
SET @Country = 'Mexico'
SELECT @Country AS Country2
GO


--3
DECLARE @FirstName AS nvarchar(25)
        ,@LastName AS nvarchar(25)
        ,@FullName AS nvarchar(50)

SELECT 
    @FirstName = FirstName
    ,@LastName = LastName
FROM Employee
WHERE EmployeeId = 1
SET @FullName = CONCAT(@FirstName, ' ', @LastName)
SELECT @FullName AS FullName
GO


--4
DECLARE @FirstName AS nvarchar(25)
        ,@LastName AS nvarchar(25)
        ,@FullName AS nvarchar(50)

SELECT 
    @FirstName = FirstName
    ,@LastName = LastName
FROM Employee
WHERE EmployeeId = 1
SET @FullName = CONCAT(@FirstName, ' ', @LastName)
PRINT @FullName
GO


--5
DECLARE @TrackName AS nvarchar(250)
        ,@Composer AS nvarchar(250)

SELECT 
    @TrackName = Name
    ,@Composer = Composer
FROM Track
WHERE TrackId = 3485
SELECT @TrackName AS TrackName, @Composer AS Composer
GO


--6
DECLARE @Answer AS numeric(9,2) = 1
SET @Answer += 10
SET @Answer -= 2
SET @Answer *= 12
SET @Answer %= 50
SET @Answer /= 5
SELECT @Answer AS Answer
GO


--7
DECLARE @Filter AS nvarchar(250) = 'Hendrix'
SELECT *
FROM Track
WHERE Composer LIKE '%'+ @Filter + '%'
GO


--8
DECLARE @Country AS nvarchar(50) = 'USA'
DECLARE @CustomerIds AS table (ID int)
INSERT INTO @CustomerIds
SELECT CustomerId
FROM Customer
WHERE Country = @Country

SELECT 
    COUNT(*) AS NumberOfCustomers
FROM Customer 
WHERE CustomerId IN (SELECT ID FROM @CustomerIds)

SELECT 
    COUNT(*) AS NumberOfInvoices
FROM Invoice 
WHERE CustomerId IN (SELECT ID FROM @CustomerIds)

SELECT 
    MAX(Total) AS HighestInvoice
FROM Invoice 
WHERE CustomerId IN (SELECT ID FROM @CustomerIds)
GO


--9
DECLARE @CustomerOrders AS table
        (
            CustomerId int
            ,CustomerName nvarchar(50)
            ,InvoiceDate date
            ,Total numeric(9,2)
        )
INSERT INTO @CustomerOrders(CustomerId, CustomerName, InvoiceDate, Total)
SELECT 
    C.CustomerId
    ,CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName
    ,I.InvoiceDate
    ,I.Total
FROM Customer C
JOIN Invoice I ON I.CustomerId = C.CustomerId
WHERE C.Country = 'Portugal'

SELECT *
FROM @CustomerOrders
ORDER BY InvoiceDate
GO


--10
DECLARE @SQL AS nvarchar(300)
DECLARE @Columns AS nvarchar(250) = 'InvoiceId, InvoiceDate, BillingCountry'
DECLARE @Table AS nvarchar(50) = 'Invoice'
DECLARE @Filter AS nvarchar(50) = 'BillingCountry = ''Italy'''

SET @SQL = 'SELECT ' + @Columns + ' FROM ' + @Table + ' WHERE ' + @Filter

PRINT @SQL
EXEC(@SQL)


