--Derek Podimatis

USE Chinook


--1
DECLARE @Country AS varchar(25) = 'Canada'
SELECT @Country AS Country


--2
GO
DECLARE @Country AS varchar(25) = 'Canada'
SELECT @Country AS Country1
SET @Country = 'Mexico'
SELECT @Country AS Country2


--3
DECLARE @FirstName AS varchar(25)
        ,@LastName AS varchar(25)
        ,@FullName AS varchar(50)

SELECT @FirstName = FirstName, @LastName = LastName
FROM Employee
WHERE EmployeeId = 1

SET @FullName = CONCAT(@FirstName, ' ', @LastName)

SELECT @FullName AS FullName


--4
GO
DECLARE @FirstName AS varchar(25)
        ,@LastName AS varchar(25)
        ,@FullName AS varchar(50)

SELECT @FirstName = FirstName, @LastName = LastName
FROM Employee
WHERE EmployeeId = 1

SET @FullName = CONCAT(@FirstName, ' ', @LastName)

PRINT @FullName


--5
DECLARE @TrackName AS varchar(300)
        ,@Composer AS varchar(50)

SELECT @TrackName = Name, @Composer = Composer
FROM Track
WHERE TrackId = 3485

SELECT @TrackName AS TrackName, @Composer AS Composer


--6
DECLARE @Answer AS decimal(9,2) = 1
SET @Answer += 10
SET @Answer -=2
SET @Answer *=12
SET @Answer %= 50
SET @Answer /= 5
SELECT @Answer AS Answer


--7
DECLARE @Filter AS varchar(50) = 'Hendrix'
SELECT *
FROM Track
WHERE Composer LIKE CONCAT('%',@Filter,'%')


--8
DECLARE @Country AS varchar(25) = 'USA'
DECLARE @CustomerIds AS table
        (
            ID int 
        )

INSERT INTO @CustomerIds
SELECT CustomerId
FROM Customer
WHERE Country = @Country

SELECT 
    COUNT(CustomerId) AS NumberOfCustomers
FROM Customer 
WHERE CustomerId IN (SELECT * FROM @CustomerIds)

SELECT 
    COUNT(InvoiceId) AS NumberOfInvoices
FROM Invoice 
WHERE CustomerId IN (SELECT * FROM @CustomerIds)

SELECT 
    MAX(Total) AS HighestInvoice
FROM Invoice 
WHERE CustomerId IN (SELECT * FROM @CustomerIds)


--9
DECLARE @CustomerOrders AS table
        (
            CustomerId int
            ,CustomerName varchar(50)
            ,InvoiceDate DATE
            ,Total DECIMAL(9,2)
        )

INSERT INTO @CustomerOrders
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


--10
GO
DECLARE @SQL AS nvarchar(300)
DECLARE @Columns AS varchar(50) = 'InvoiceId, InvoiceDate, BillingCountry'
DECLARE @Table AS varchar(50) = 'Invoice'
DECLARE @Filter AS varchar(50) = 'BillingCountry = ''Italy'''

SET @SQL = 'SELECT ' + @Columns + ' FROM ' + @Table + ' WHERE ' + @Filter

PRINT @SQL
EXEC(@SQL)