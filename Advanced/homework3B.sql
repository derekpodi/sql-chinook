--Derek Podimatis

USE Chinook


--1
PRINT 'First Statement'
RETURN
PRINT 'Second Statement'
PRINT 'Third Statement'
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
PRINT 'End of Loop.'
GO


--5
DECLARE @EmployeeName AS table (FullName nvarchar(50))
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = MAX(EmployeeId) FROM Employee
WHILE @Counter <= @MaxId
BEGIN
INSERT INTO @EmployeeName
SELECT
    CONCAT(FirstName, ' ', LastName)
FROM Employee
WHERE EmployeeId = @Counter
SET @Counter += 1
END
SELECT * FROM @EmployeeName
GO


--6
DECLARE @SumTotal numeric(9,2) = 0
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = MAX(InvoiceId) FROM Invoice
WHILE @Counter <= @MaxId
BEGIN
IF (SELECT Total FROM Invoice WHERE InvoiceId = @Counter) > 0.99
BEGIN
    SET @Counter += 1
    CONTINUE 
END
SET @SumTotal += (SELECT Total FROM Invoice WHERE InvoiceId = @Counter)
SET @Counter += 1
END
SELECT @SumTotal AS [Sum Total of Invoices less than a Dollar]
GO


--7
DECLARE @RollingTable AS table (Amount numeric(9,2), RollingTotal numeric(9,2), Note nvarchar(50))
DECLARE @Sum numeric(9,2) = 0
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = MAX(InvoiceId) FROM Invoice
WHILE (@Counter <= @MaxId)
BEGIN
Set @Sum += (SELECT Total FROM Invoice WHERE InvoiceId = @Counter)
INSERT INTO @RollingTable(Amount, RollingTotal, Note)
SELECT
    Total
    ,@Sum
    ,CONCAT('InvoiceId: ',@Counter)
FROM Invoice
WHERE InvoiceId = @Counter
IF @Sum > 50
BEGIN
    UPDATE @RollingTable
    SET Note = 'Total greater than 50.'
    WHERE RollingTotal = @Sum    
    BREAK
END
SET @Counter += 1
END
SELECT * FROM @RollingTable
GO



--8
DECLARE @RandomArtist nvarchar(250)
SET @RandomArtist = (SELECT TOP 1 Name FROM Artist ORDER BY NEWID())
PRINT @RandomArtist
GO 7


--9
PRINT 'First Statement'
GOTO Third
Second:
PRINT 'Second Statement'
RETURN
Third:
PRINT 'Third Statement'
GOTO SECOND
GO


--10
DECLARE @FirstName AS nvarchar(25)
DECLARE @LastName AS nvarchar(25)
DECLARE @EmployeeId AS int
DECLARE @City AS nvarchar(50)
DECLARE @Counter int = 1
DECLARE @MaxId int
SELECT @MaxId = MAX(EmployeeId) FROM Employee
WHILE (@Counter <= @MaxId)
BEGIN
SELECT
    @FirstName = FirstName
    ,@LastName = LastName
    ,@EmployeeId = EmployeeId
    ,@City = City
FROM Employee
WHERE EmployeeId = @Counter
RAISERROR('%s %s has and ID of %d and lives in the city of %s.', 10, 1, @FirstName, @LastName, @EmployeeId, @City)
SET @Counter += 1
END

