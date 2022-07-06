--Derek Podimatis

USE Chinook

--1
Select
    Name
    ,REPLACE(Name, ' & ', ' and ') AS NewName
FROM Genre
WHERE Name LIKE '%&%'


--2
SELECT
    CONCAT(FirstName, ' ', LastName) AS FullName
    ,DAY(BirthDate) AS Day
    ,DATENAME(month, BirthDate) AS Month
    ,YEAR(BirthDate) AS Year
FROM Employee


--3
SELECT
    REPLACE(Title, ' ', '') AS TitleNoSpaces
    ,UPPER(Title) AS TitleUpperCase
    ,REVERSE(Title) AS TitleReverse
    ,LEN(Title) AS TitleLength
    ,CHARINDEX(' ', Title) AS SpaceLocation
FROM Album


--4
SELECT
    FirstName
    ,LastName
    ,BirthDate
    ,DATEDIFF(day, Birthdate,GETDATE())/365 AS Age
FROM Employee


--5
SELECT 
    Title
    ,TRIM(SUBSTRING(Title, CHARINDEX(' ', Title)+1, LEN(Title))) AS ShortTitle
FROM Employee


--6
SELECT
    FirstName
    ,LastName
    ,CONCAT(Left(TRIM(FirstName),1), Left(TRIM(LastName), 1)) AS Initials
FROM Customer
ORDER BY Initials


--7
SELECT 
    FirstName
    ,LastName
    --,CONCAT(FirstName, ' ', LastName) AS Name
    ,TRIM(REPLACE(REPLACE(Phone, '+1', ''), '-', ' ')) AS Phone
    ,ISNULL(TRIM(REPLACE(REPLACE(Fax,'+1', ''), '-', ' ')), 'Unknown') AS Fax
FROM Customer
WHERE Country = 'USA'
ORDER BY LastName


--8
SELECT
    UPPER(CONCAT(LastName, ', ', FirstName)) AS CustomerName
    ,ISNULL(Company,'N/A') AS Company
FROM Customer
WHERE LastName LIKE '[A-M]%'


--9
SELECT
    InvoiceId
    ,CustomerId
    ,Total
    ,CONVERT(date, InvoiceDate) AS InvoiceDate
    ,CONCAT('FY', IIF(MONTH(InvoiceDate) <= 6, YEAR(InvoiceDate), YEAR(InvoiceDate)+1)) AS FiscalYear
FROM Invoice
ORDER BY InvoiceDate DESC


--10
SELECT 
    IIF(Country = 'USA' OR Country = 'Canada', 'Domestic', 'International') AS CustomerType
    ,FirstName
    ,LastName
    ,Country
FROM Customer
ORDER BY CustomerType, LastName 

