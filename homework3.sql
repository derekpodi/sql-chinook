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
    ,DAY(BirthDate) AS [Day]
    ,DATENAME(MONTH, BirthDate) AS [Month]
    ,YEAR(BirthDate) AS [Year]
FROM Employee


--3
SELECT
    REPLACE(Title, ' ', '') AS TitleNoSpaces
    ,UPPER(Title) AS TitleUpperCase
    ,REVERSE(Title) AS TitleReverse
    ,LEN(Title) AS TitleLength
    ,PATINDEX('% %',Title) AS SpaceLocation 
FROM Album


--4
SELECT
    FirstName
    ,LastName
    ,BirthDate
    --,DATEDIFF(DAY, Birthdate,GETDATE())/365 AS Age    --My original answer
    ,DATEDIFF(HOUR,BirthDate,GETDATE())/8766 AS Age
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
    ,CONCAT(Left(FirstName,1), Left(LastName, 1)) AS Initials
FROM Customer
ORDER BY Initials


--7
SELECT 
    FirstName
    ,LastName
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
ORDER BY CustomerName


--9
SELECT
    InvoiceId
    ,CustomerId
    ,Total
    ,CONVERT(date, InvoiceDate) AS InvoiceDate
    --,CONCAT('FY', IIF(MONTH(InvoiceDate) <= 6, YEAR(InvoiceDate), YEAR(InvoiceDate)+1)) AS FiscalYear     --My original answer
    ,CONCAT('FY',YEAR(DATEADD(MONTH,6,InvoiceDate))) AS FiscalYear 
FROM Invoice
ORDER BY InvoiceDate DESC


--10
SELECT 
    IIF(Country IN('USA','Canada'),'Domestic','International') AS CustomerType 
    ,FirstName
    ,LastName
    ,Country
FROM Customer
ORDER BY CustomerType, LastName 


