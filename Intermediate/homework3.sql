--Derek Podimatis

USE Chinook;

--1
WITH AA AS
(
SELECT
    A.ArtistId
    ,A.Name AS ArtistName
    ,AL.AlbumId
    ,AL.Title AS AlbumTitle
FROM Artist A
JOIN Album AL
    ON AL.ArtistId = A.ArtistId
WHERE A.Name = 'AudioSlave'
)
SELECT
    AA.ArtistName
    ,AA.AlbumTitle
    ,T.Name AS TrackName
FROM AA
JOIN Track T
    ON T.AlbumId = AA.AlbumId


--2
SELECT
    AA.ArtistName
    ,AA.AlbumTitle
    ,T.Name AS TrackName
FROM
(
    SELECT
        A.ArtistId
        ,A.Name AS ArtistName
        ,AL.AlbumId
        ,AL.Title AS AlbumTitle
    FROM Artist A
    JOIN Album AL
        ON AL.ArtistId = A.ArtistId
    WHERE A.Name = 'Kiss'
) AS AA
JOIN Track T
    ON T.AlbumId = AA.AlbumId;


--3
WITH CustomerInvoice AS
(
SELECT
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName
    ,SUM(I.Total) AS SumTotal
    ,C.SupportRepId
FROM Customer C
JOIN Invoice I
    ON I.CustomerId = C.CustomerId
GROUP BY CONCAT(C.FirstName, ' ', C.LastName), C.SupportRepId
)
SELECT
    E.LastName AS SupportRep
    ,CustomerInvoice.CustomerName
    ,CustomerInvoice.SumTotal
FROM CustomerInvoice
JOIN Employee E
    ON E.EmployeeId = CustomerInvoice.SupportRepId
ORDER BY SumTotal DESC, LastName


--4
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,(
        SELECT COUNT(*)
        FROM Track T
        WHERE T.AlbumId = AL.AlbumId
    ) AS TrackCount
FROM Album AL
JOIN Artist A 
    ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'Iron Maiden'
ORDER BY TrackCount;


--5
WITH TC AS 
(
SELECT 
    AlbumId
    ,COUNT(*) AS TrackCount
FROM Track
GROUP BY AlbumId
)
SELECT
    A.Name AS ArtistName
    ,AL.Title AS AlbumTitle
    ,TC.TrackCount
FROM Artist A
JOIN Album AL
    ON AL.ArtistId = A.ArtistId
JOIN TC 
    ON TC.AlbumId = AL.AlbumId
WHERE A.Name = 'U2'
ORDER BY TrackCount;


--6
WITH BD AS
(
SELECT
    CONCAT(FirstName, ' ', LastName) AS FullName
    ,BirthDate
    ,DATEFROMPARTS(2021,MONTH(BirthDate),DAY(BirthDate)) AS BirthDay2021
FROM Employee
)
, CD AS
(
SELECT
    FullName
    ,BirthDate
    ,BirthDay2021
    ,CASE
        WHEN DATENAME(WEEKDAY, BD.BirthDay2021) = 'Saturday' THEN DATEADD(day, 2, BD.BirthDay2021)
        WHEN DATENAME(WEEKDAY, BD.BirthDay2021) = 'Sunday' THEN DATEADD(day, 1, BD.BirthDay2021)
        ELSE BD.BirthDay2021 
        END AS CelebrationDate
FROM BD
)
SELECT
    FullName
    ,CONVERT(VARCHAR, BirthDate, 110) AS BirthDate
    ,CONVERT(VARCHAR, BirthDay2021, 110) AS BirthDay2021
    ,DATENAME(WEEKDAY, BirthDay2021) AS BirthDayOfWeek2021
    ,CONVERT(VARCHAR, CelebrationDate, 110) AS CelebrationDate
    ,DATENAME(WEEKDAY, CD.CelebrationDate) AS CelebrationDayOfWeek
FROM CD



/********************** Trigger Setup ****************************/
GO
USE master
IF DB_ID('MyDB_dp') IS NOT NULL --Execute code below if the database exists.
BEGIN
    ALTER DATABASE MyDB_dp SET OFFLINE WITH ROLLBACK IMMEDIATE; --Removes connections to database.
    ALTER DATABASE MyDB_dp SET ONLINE; --Return online so DROP command will succeed.
    DROP DATABASE MyDB_dp; --Drop the database
END
CREATE DATABASE MyDB_dp
GO
USE MyDB_dp

--Create sample table.
SELECT *
INTO Staff
FROM Chinook.dbo.Employee

--Create log table.
SELECT
    CAST('' AS varchar(20)) AS DMLType
    ,sysdatetime() AS DateUpdated
    ,SYSTEM_USER AS UpdatedBy
    ,*
INTO Staff_log
FROM Chinook.dbo.Employee
WHERE 1=2 --Table creation shortcut. By setting 1=2 the table gets created but no data is inserted.
/****************************************************************/


--7
UPDATE Staff
SET Title = 'New General Manager'
OUTPUT inserted.EmployeeId, deleted.Title AS TitleBefore, inserted.Title AS TitleAfter
WHERE FirstName = 'Nancy' AND LastName = 'Edwards'


--8
GO
CREATE TRIGGER Staff_trg
    ON Staff
    AFTER UPDATE, DELETE
    AS
    INSERT INTO Staff_log(DMLType, DateUpdated, UpdatedBy, EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, [State], Country, PostalCode, Phone, Fax, Email)
    SELECT
    CASE
        WHEN EXISTS (SELECT * FROM deleted)
            AND NOT EXISTS (SELECT * FROM inserted) THEN 'deleted'
        ELSE 'inserted'
        END
    ,SYSDATETIME()
    ,SYSTEM_USER
    ,COALESCE(D.EmployeeId, I.EmployeeId)
    ,COALESCE(D.LastName, I.LastName)
    ,COALESCE(D.FirstName, I.FirstName)
    ,COALESCE(D.Title, I.Title)
    ,COALESCE(D.ReportsTo, I.ReportsTo)
    ,COALESCE(D.BirthDate, I.BirthDate)
    ,COALESCE(D.HireDate, I.HireDate)
    ,COALESCE(D.Address, I.Address)
    ,COALESCE(D.City, I.City)
    ,COALESCE(D.State, I.State)
    ,COALESCE(D.Country, I.Country)
    ,COALESCE(D.PostalCode, I.PostalCode)
    ,COALESCE(D.Phone, I.Phone)
    ,COALESCE(D.Fax, I.Fax)
    ,COALESCE(D.Email, I.Email)
    FROM deleted D 
    FULL JOIN inserted I
        ON I.EmployeeId = D.EmployeeId


--9
DELETE Staff
WHERE FirstName = 'Andrew' AND LastName = 'Adams'


--10
UPDATE Staff
SET Title = 'New Sales Manager'
WHERE FirstName = 'Jane' AND LastName = 'Peacock'

--11
SELECT *
FROM Staff

SELECT *
FROM Staff_log