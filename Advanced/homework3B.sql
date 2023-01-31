--Derek Podimatis

USE Chinook


--1
PRINT('First Statement')
RETURN
PRINT('Second Statement')
PRINT('Third Statement')
GO


--2
DECLARE @Counter int = 0
IF @Counter = 1
BEGIN
SELECT TOP 1 * FROM Artist
SELECT TOP 1 * FROM Genre
END
SELECT TOP 1 * FROM MediaType
GO


--3
DECLARE @Counter int = 1
IF @Counter = 1
BEGIN
SELECT TOP 1 * FROM Artist
END
ELSE
BEGIN
SELECT TOP 1 * FROM Genre
END
SELECT TOP 1 * FROM MediaType
GO


--4
DECLARE @Counter int = 1
WHILE @Counter <= 5
BEGIN
PRINT CONCAT('Counter Number: ', @Counter)
SET @Counter += 1
END
PRINT('End of Loop.')
GO


--5
DECLARE @EmployeeName AS table (FullName nvarchar(50))
DECLARE @FullName AS nvarchar(50)
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = COUNT(*) FROM Employee
WHILE (@Counter <= @MaxId)
BEGIN
SELECT
    @FullName = CONCAT(FirstName, ' ', LastName)
FROM Employee
WHERE EmployeeId = @Counter
INSERT INTO @EmployeeName
VALUES(@FullName)
SET @Counter += 1
END
SELECT * FROM @EmployeeName
GO


--6
DECLARE @SumTotal numeric(9,2) = 0
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = COUNT(*) FROM Invoice
WHILE (@Counter <= @MaxId)
BEGIN
SELECT 
    @SumTotal += Total 
FROM Invoice
WHERE Total < 1.00 AND InvoiceId = @Counter
SET @Counter += 1
END
SELECT @SumTotal AS [Sum Total of Invoices less than a Dollar]
GO


--7
DECLARE @RunningTable AS table (Amount numeric(9,2), RollingTotal numeric(9,2), Note nvarchar(50))
DECLARE @Amount numeric(9,2) = 0
DECLARE @RollingTotal numeric(9,2) = 0
DECLARE @Note nvarchar(50)
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = COUNT(*) FROM Invoice
WHILE (@Counter <= @MaxId)
BEGIN
SELECT
    @Amount = Total
    ,@RollingTotal += Total
    ,@Note = CONCAT('InvoiceId: ', @Counter)
FROM Invoice I
WHERE InvoiceId = @Counter
IF @RollingTotal >= 50
    BEGIN
    INSERT INTO @RunningTable
    VALUES(@Amount, @RollingTotal, 'Total greater than 50.')
    BREAK
    END
INSERT INTO @RunningTable
VALUES(@Amount, @RollingTotal, @Note)
SET @Counter += 1
END
SELECT * FROM @RunningTable
GO



--8
DECLARE @RandomArtist nvarchar(250)
SELECT TOP 1 @RandomArtist = Name FROM Artist ORDER BY NEWID()
PRINT(@RandomArtist)
GO 7


--9
PRINT('First Statement')

GOTO Third

Third:
PRINT('Third Statement')
GOTO SECOND

Second:
PRINT('Second Statement')
RETURN
GO


--10
DECLARE @EmployeeT AS table (FirstName nvarchar(50),LastName nvarchar(50),EmployeeId int,City nvarchar(50))
DECLARE @FirstName AS nvarchar(50)
DECLARE @LastName AS nvarchar(50)
DECLARE @EmployeeId AS int
DECLARE @City AS nvarchar(50)
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = COUNT(*) FROM Employee
WHILE (@Counter <= @MaxId)
BEGIN
SELECT
    @FirstName = FirstName
    ,@LastName = LastName
    ,@EmployeeId = EmployeeId
    ,@City = City
FROM Employee
WHERE EmployeeId = @Counter
INSERT INTO @EmployeeT
VALUES(@FirstName, @LastName, @EmployeeId, @City)
RAISERROR('%s %s has and ID of %d and lives in the city of %s.', 10, 1, @FirstName, @LastName, @EmployeeId, @City) WITH NOWAIT
SET @Counter += 1
END

