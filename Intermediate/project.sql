
--------DROP DATABSE TO START CLEAN FOR EACH RUN ------
USE master
IF DB_ID('LSP_dp') IS NOT NULL
BEGIN
    ALTER DATABASE LSP_dp SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE LSP_dp SET ONLINE;
    DROP DATABASE LSP_dp;
END

GO


-------- CREATE DATABASES --------
CREATE DATABASE LSP_dp
GO
USE LSP_dp 


-------- CREATE TABLES --------
CREATE TABLE Course(
    CourseID int PRIMARY KEY IDENTITY(1,1)
    ,CourseCode varchar(50)
    ,CourseTitle varchar(100)
    ,TotalWeeks SMALLINT
    ,TotalHours FLOAT
    ,FullCourseFee SMALLINT
    ,CourseDescription varchar(350)
)

CREATE TABLE Room(
    RoomID int PRIMARY KEY IDENTITY(1,1)
    ,RoomName varchar(50)
    ,Capacity SMALLINT
)

CREATE TABLE Term(
    TermID int PRIMARY KEY
    ,TermCode varchar(50)
    ,TermName varchar(50)
    ,CalendarYear SMALLINT
    ,AcademicYear SMALLINT
)

CREATE TABLE Section(
    SectionID int PRIMARY KEY
    ,CourseID int FOREIGN KEY REFERENCES Course(CourseID)
    ,TermID int FOREIGN KEY REFERENCES Term(TermID)
    ,RoomID int FOREIGN KEY REFERENCES Room(RoomID)
    ,CourseCode varchar(50)
    ,CourseTitle varchar(100)
    ,TermCode varchar(50)
    ,StartDate DATE
    ,EndDate DATE
    ,Days varchar(50)
    ,SectionStatus varchar(50)
    ,RoomName varchar(50)
    ,PrimaryInstructor varchar(50)
    ,PrimaryPayment INT
    ,SecondaryInstructor varchar(50)
    ,SecondaryPayment INT
)

CREATE TABLE Person(
    PersonID int PRIMARY KEY
    ,LastName varchar(50)
    ,FirstName varchar(50)
    ,MiddleName varchar(50)
    ,Gender varchar(50)
    ,Phone varchar(50)
    ,Email varchar(50)
    ,AddressLine varchar(50)
    ,City varchar(50)
    ,State varchar(50)
    ,PostalCode varchar(50)
)

CREATE TABLE Address(
    AddressID int PRIMARY KEY IDENTITY(1,1)
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID)
    ,AddressType varchar(50)
    ,AddressLine varchar(50)
    ,City varchar(50)
    ,State varchar(50)
    ,PostalCode varchar(50)
)

CREATE TABLE ClassList(
    ClassListID int PRIMARY KEY IDENTITY(1,1)
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID)
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID)
    ,LastName varchar(50)
    ,FirstName varchar(50)
    ,Phone varchar(50)
    ,Email varchar(50)
    ,EnrollmentStatus varchar(50)
    ,TuitionAmount int
    ,Grade varchar(50)
    ,TermID int FOREIGN KEY REFERENCES Term(TermID)
)

CREATE TABLE Faculty(
    FacultyID int PRIMARY KEY IDENTITY(1,1)
    ,FacultyFirstName varchar(50)
    ,FacultyLastName varchar(50)
    ,FacultyEmail varchar(50)
    ,PrimaryPhone varchar(50)
    ,AlternativePhone varchar(50)
    ,FacultyAddressLine varchar(50)
    ,FacultyCity varchar(50)
    ,FacultyState varchar(50)
    ,FacultyPostalCode int
)

CREATE TABLE FacultyPayment(
    FacultyPaymentID int PRIMARY KEY IDENTITY(1,1)
    ,FacultyID int FOREIGN KEY REFERENCES Faculty(FacultyID)
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID)
)



--------INSERT DATA--------
--Course
INSERT INTO [LSP_dp]..Course
(
  [CourseCode]
  ,[CourseTitle]
  ,[TotalWeeks]
  ,[TotalHours]
  ,[FullCourseFee]
  ,[CourseDescription]
)
SELECT [CourseCode], [CourseTitle], [TotalWeeks], [TotalHours], [FullCourseFee], [CourseDescription]
FROM [LSP_stage]..[Courses15]
UNION
SELECT [CourseCode], [CourseTitle], [TotalWeeks], [TotalHours], [FullCourseFee], [CourseDescription]
FROM [LSP_stage]..[Courses19]


--Room
INSERT INTO [LSP_dp]..Room
(
  [RoomName]
  ,[Capacity]
)
SELECT [RoomName], [Capacity]
FROM [LSP_stage]..[Rooms15]
UNION
SELECT [RoomName], [Capacity]
FROM [LSP_stage]..[Rooms19]


--Term
INSERT INTO [LSP_dp]..Term
(
  [TermID]
  ,[TermCode]
  ,[TermName]
  ,[CalendarYear]
  ,[AcademicYear]
)
SELECT [TermID], [TermCode], [TermName], [CalendarYear], [AcademicYear]
FROM [LSP_stage]..[Terms15]
UNION
SELECT [TermID], [TermCode], [TermName], [CalendarYear], [AcademicYear]
FROM [LSP_stage]..[Terms19]


--Section
INSERT INTO [LSP_dp]..Section
(
  [SectionID]
  ,[CourseID]
  ,[TermID]
  ,[RoomID]
  ,[CourseCode]
  ,[CourseTitle]
  ,[TermCode]
  ,[StartDate]
  ,[EndDate]
  ,[Days]
  ,[SectionStatus]
  ,[RoomName]
  ,[PrimaryInstructor]
  ,[PrimaryPayment]
  ,[SecondaryInstructor]
  ,[SecondaryPayment]
)
SELECT [SectionID],[CourseID], [TermID], [RoomID], S.[CourseCode], S.[CourseTitle], [TermCode], [StartDate], [EndDate], [Days], [SectionStatus], S.[RoomName], [PrimaryInstructor], [PrimaryPayment], [SecondaryInstructor], [SecondaryPayment]
FROM [LSP_stage]..[Sections SU11-SU15] S
LEFT JOIN [LSP_dp]..[Room] R ON R.RoomName = S.RoomName
LEFT JOIN [LSP_dp]..[Course] C ON C.CourseCode = S.CourseCode
UNION
SELECT [SectionID],[CourseID], [TermID], [RoomID], SF.[CourseCode], SF.[CourseTitle], [TermCode], [StartDate], [EndDate], [Days], [SectionStatus], SF.[RoomName], [PrimaryInstructor], [PrimaryPayment], [SecondaryInstructor], [SecondaryPayment]
FROM [LSP_stage]..[Sections FA15-SU19] SF
LEFT JOIN [LSP_dp]..[Room] R ON R.RoomName = SF.RoomName
LEFT JOIN [LSP_dp]..[Course] C ON C.CourseCode = SF.CourseCode



--Person
INSERT INTO [LSP_dp]..Person
(
  [PersonID]
  ,[LastName]
  ,[FirstName]
  ,[MiddleName]
  ,[Gender]
  ,[Phone]
  ,[Email]
  ,[AddressLine]
  ,[City]
  ,[State]
  ,[PostalCode]
)
SELECT [PersonID], [LastName], [FirstName], [MiddleName], [Gender], [Phone], [Email], [AddressLine], [City], [State], [PostalCode]
FROM [LSP_stage]..[Persons15]
UNION
SELECT [PersonID], [LastName], [FirstName], [MiddleName], [Gender], [Phone], [Email], [AddressLine], [City], [State], [PostalCode]
FROM [LSP_stage]..[Persons19]


--Address
INSERT INTO [LSP_dp]..Address
(
  [PersonID]
  ,[AddressType]
  ,[AddressLine]
  ,[City]
  ,[State]
  ,[PostalCode]
)
SELECT [PersonID], 'home' AS [AddressType], [AddressLine], [City], [State], [PostalCode]
FROM [LSP_stage]..[Persons15]
UNION
SELECT [PersonID], 'home' AS [AddressType], [AddressLine], [City], [State], [PostalCode]
FROM [LSP_stage]..[Persons19]


--ClassList
INSERT INTO [LSP_dp]..ClassList
(
  [SectionID]
  ,[PersonID]
  ,[LastName]
  ,[FirstName]
  ,[Phone]
  ,[Email]
  ,[EnrollmentStatus]
  ,[TuitionAmount]
  ,[Grade]
  ,[TermID]
)
SELECT S.[SectionID], [PersonID], [LastName], [FirstName], [Phone], [Email], [EnrollmentStatus], [TuitionAmount], [Grade], CL.[TermID]
FROM [LSP_stage]..[Classlist SU11-SU15] CL
LEFT JOIN [LSP_dp]..[Section] S ON S.SectionID = CL.SectionID
UNION
SELECT S.[SectionID], [PersonID], [LastName], [FirstName], [Phone], [Email], [EnrollmentStatus], [TuitionAmount], [Grade], CLF.[TermID]
FROM [LSP_stage]..[ClassList FA15-SU19] CLF
LEFT JOIN [LSP_dp]..[Section] S ON S.SectionID = CLF.SectionID


--Faculty
INSERT INTO [LSP_dp]..Faculty
(
  [FacultyFirstName]
  ,[FacultyLastName]
  ,[FacultyEmail]
  ,[PrimaryPhone]
  ,[AlternativePhone]
  ,[FacultyAddressLine]
  ,[FacultyCity]
  ,[FacultyState]
  ,[FacultyPostalCode]
)
SELECT [FacultyFirstName], [FacultyLastName], [FacultyEmail], [PrimaryPhone], [AlternatePhone], [FacultyAddressLine], [FacultyCity], [FacultyState], [FacultyPostalCode]
FROM [LSP_stage]..[Faculty15]
UNION
SELECT [FacultyFirstName], [FacultyLastName], [FacultyEmail], [PrimaryPhone], [AlternatePhone], [FacultyAddressLine], [FacultyCity], [FacultyState], [FacultyPostalCode]
FROM [LSP_stage]..[Faculty19]


--FacultyPayment
INSERT INTO [LSP_dp]..FacultyPayment
(
  [FacultyID]
  ,[SectionID]
)
SELECT [FacultyID], [SectionID]
FROM [LSP_dp]..[Faculty] F 
LEFT JOIN Section S ON SUBSTRING(S.PrimaryInstructor, 4, LEN(S.PrimaryInstructor)) = F.FacultyLastName


GO


--------ADDITIONAL DATABASE OBJECTS--------
--1.
CREATE VIEW CourseRevenue_v AS
SELECT
    C.[CourseCode]
    ,C.[CourseTitle]
    ,COUNT(S.SectionID) AS SectionCount
    ,COUNT(S.SectionID) * C.FullCourseFee AS [Total Gross Revenue]
    ,(COUNT(S.SectionID) * C.FullCourseFee) / COUNT(S.SectionID) AS [AVG Revenue Per Section]
FROM Course C
JOIN Section S ON S.CourseID = C.CourseID
WHERE S.SectionStatus != 'CN'
GROUP BY C.[CourseCode], C.[CourseTitle], C.[FullCourseFee]


GO
--2.
CREATE VIEW AnnualRevenue_v AS
WITH CTE AS(
    SELECT
    F.FacultyID 
    ,T.AcademicYear
    ,CONCAT(F.FacultyFirstName, ' ', F.FacultyLastName) AS FacultyName
    ,COUNT(S.SectionID) * C.FullCourseFee AS [Total Gross Revenue]
FROM Course C
JOIN Section S ON S.CourseID = C.CourseID
JOIN FacultyPayment FP ON FP.SectionID = S.SectionID
JOIN Faculty F ON F.FacultyID = FP.FacultyID
JOIN Term T ON S.TermID = T.TermID
WHERE S.SectionStatus != 'CN'
GROUP BY F.[FacultyID], T.[AcademicYear], C.[FullCourseFee], CONCAT(F.FacultyFirstName, ' ', F.FacultyLastName)
)
SELECT
    CTE.FacultyID
    ,CTE.FacultyName
    ,CTE.AcademicYear
    ,SUM(CTE.[Total Gross Revenue]) AS [Gross Revenue from Tuition]
FROM CTE
GROUP BY CTE.FacultyID, CTE.FacultyName, CTE.AcademicYear

GO

--3.
CREATE PROC StudentHistory_p @PersonPrimaryKey int AS
SELECT
    CONCAT(P.FirstName, ' ', P.LastName) AS [Student Name]
    ,S.[SectionID] AS [Section ID]
    ,S.[CourseCode] AS [Course Code]
    ,S.[CourseTitle] AS [Course Title]
    ,S.[PrimaryInstructor] AS [Primary Instructor Name]
    ,S.[TermCode] AS [Term Code]
    ,S.[StartDate] AS [Start Date]
    ,CL.[TuitionAmount] AS [Tuition Paid]
    ,CL.[Grade] AS [Grade]
FROM Person P
JOIN ClassList CL ON CL.PersonID = P.PersonID
JOIN Section S ON S.SectionID = CL.SectionID
WHERE P.PersonID = @PersonPrimaryKey


GO
--4.
CREATE PROC InsertPerson_p
    @PersonFirstName varchar(50)
    ,@PersonLastName varchar(50)
    ,@AddressAddressType varchar(50)
    ,@AddressAddressLine varchar(50)
    ,@AddressCity varchar(50) AS
BEGIN
    INSERT INTO Person(PersonID, FirstName, LastName)
    SELECT MAX(PersonID) + 1, @PersonFirstName, @PersonLastName FROM Person;

    INSERT INTO Address(PersonID, AddressType, AddressLine, City)
    SELECT MAX(PersonID), @AddressAddressType, @AddressAddressLine, @AddressCity FROM Person;
END





GO
---------EXECUTE CODE FOR SCREENSHOTS--------
--1
SELECT * FROM CourseRevenue_v ORDER BY CourseCode
--2
SELECT * FROM AnnualRevenue_v ORDER BY AcademicYear
--3
EXEC StudentHistory_p 1400
--4
EXEC InsertPerson_p 'Eric','Williamson','work','500 Elm St.','North Pole'
SELECT TOP 1 * FROM Person ORDER BY PersonID DESC
SELECT TOP 1 * FROM Address ORDER BY AddressID DESC





/*
-------- DROP OBJECTS --------
DROP TABLE Section

DROP TABLE Course

DROP TABLE Room

DROP TABLE Term

DROP TABLE ClassList

DROP TABLE Person

DROP TABLE Address

DROP TABLE FacultyPayment

DROP TABLE Faculty

DROP DATABASE LSP_dp;
*/



--Script DB - ERD
--https://stackoverflow.com/questions/59852790/script-database-with-azure-data-studio
--https://www.sqlshack.com/generate-data-scripts-using-ssms-and-azure-data-studio/
--https://stackoverflow.com/questions/53293349/azure-data-studio-schema-diagram
--https://www.sqlshack.com/sql-server-data-import-using-azure-data-studio/
--https://learnsql.com/cookbook/how-to-create-a-table-with-a-foreign-key-in-sql/


/*
-------WORKING AREA------
USE LSP_stage

--Max Col Length for CourseDescription(301)
SELECT TOP (100)
    [CourseDescription]
    ,LEN([CourseDescription])
FROM [LSP_stage].[dbo].[Courses15]
ORDER BY LEN([CourseDescription]) DESC

SELECT TOP (100)
    [CourseTitle]
    ,LEN([CourseTitle])
FROM [LSP_stage].[dbo].[Courses19]
ORDER BY LEN([CourseTitle]) DESC


--Rooms
SELECT *
FROM [Rooms15]
UNION
SELECT *
FROM [Rooms19]

--TERM
SELECT *
FROM [Terms15]
UNION
SELECT *
FROM [Terms19]

--Courses
SELECT *
FROM [Courses15]
UNION
SELECT *
FROM [Courses19]

--Sections
SELECT *
FROM [Sections SU11-SU15]
UNION 
SELECT *
FROM [Sections FA15-SU19]

--Persons
SELECT *
FROM [Persons15]
UNION
SELECT *
FROM [Persons19]

--ClassList
SELECT *
FROM [Classlist SU11-SU15]
UNION
SELECT *
FROM [ClassList FA15-SU19]

--Faculty
SELECT *
FROM [Faculty15]
UNION
SELECT *
FROM [Faculty19]

--Dupe Section ID 
WITH CTE AS(
    SELECT *
    FROM [Sections SU11-SU15]
    UNION
    SELECT *
    FROM [Sections FA15-SU19]
)
SELECT
    SectionID
    ,COUNT(SectionID)
FROM CTE
GROUP BY SectionID
ORDER BY COUNT(SectionID) DESC

--DELETE DUPE
DELETE FROM [Sections SU11-SU15] WHERE SectionID = 10050 AND PrimaryInstructor IS NULL

*/