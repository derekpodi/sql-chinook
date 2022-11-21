
--------DROP DATABSE TO START CLEAN FOR EACH RUN ------
USE master
IF DB_ID('LSP_dp') IS NOT NULL
BEGIN
    ALTER DATABASE LSP_dp SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE LSP_dp SET ONLINE;
    DROP DATABASE LSP_dp;
END



------------------ CREATE DATABASE ------------------
CREATE DATABASE LSP_dp
GO
USE LSP_dp 


------------------ CREATE TABLES --------------------
CREATE TABLE Course(
    CourseID int PRIMARY KEY IDENTITY(1,1)
    ,CourseCode varchar(10)
    ,CourseTitle varchar(60)
    ,TotalWeeks int
    ,TotalHours NUMERIC(9,2)
    ,FullCourseFee NUMERIC(9,2)
    ,CourseDescription varchar(500)
)

GO
CREATE TABLE Room(
    RoomID int PRIMARY KEY IDENTITY(1,1)
    ,RoomName varchar(50)
    ,Capacity varchar(50)
)

GO
CREATE TABLE Term(
    TermID int PRIMARY KEY IDENTITY(1,1)
    ,TermCode char(4)
    ,TermName varchar(20)
    ,CalendarYear SMALLINT
    ,AcademicYear SMALLINT
)

GO
CREATE TABLE Person(
    PersonID int PRIMARY KEY IDENTITY (1,1)
    ,LastName varchar(50)
    ,FirstName varchar(35)
    ,MiddleName varchar(35)
    ,Gender char(1)
    ,Phone varchar(20)
    ,Email varchar(100)
)

GO
CREATE TABLE Section(
    SectionID int PRIMARY KEY IDENTITY(10000,1)
    ,CourseID int FOREIGN KEY REFERENCES Course(CourseID) NOT NULL
    ,TermID int FOREIGN KEY REFERENCES Term(TermID) NOT NULL
    ,RoomID int FOREIGN KEY REFERENCES Room(RoomID)
    ,StartDate DATE
    ,EndDate DATE
    ,Days varchar(50)
    ,SectionStatus varchar(50)
)

GO
CREATE TABLE Address(
    AddressID int PRIMARY KEY IDENTITY(1,1)
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID)
    ,AddressType varchar(10)
    ,AddressLine varchar(50) NOT NULL
    ,City varchar(25)
    ,State varchar(10)
    ,PostalCode varchar(15)
    ,Country varchar(25)
)

GO
CREATE TABLE ClassList(
    ClassListID int PRIMARY KEY IDENTITY(1,1)
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID) NOT NULL
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID) NOT NULL
    ,Grade varchar(2)
    ,EnrollmentStatus char(2)
    ,TuitionAmount money
)

GO
CREATE TABLE Faculty(
    FacultyID int PRIMARY KEY IDENTITY(1,1)
    ,FacultyFirstName varchar(35)
    ,FacultyLastName varchar(50)
    ,FacultyEmail varchar(100)
    ,PrimaryPhone varchar(25)
    ,AlternativePhone varchar(25)
    ,FacultyAddressLine varchar(50)
    ,FacultyCity varchar(25)
    ,FacultyState char(2)
    ,FacultyPostalCode char(5)
    ,FacultyCountry varchar(50)
)

GO
CREATE TABLE FacultyPayment(
    FacultyPaymentID int PRIMARY KEY IDENTITY(1,1)
    ,FacultyID int FOREIGN KEY REFERENCES Faculty(FacultyID)
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID)
    ,PrimaryInstructor char(1) NOT NULL
    ,PaymentAmount NUMERIC(9,2)
)

GO


----------------------INSERT DATA--------------------

-----------NO FOREIGN KEYS INSERT-------------
--Course
INSERT INTO LSP_dp..Course
(
  CourseCode
  ,CourseTitle
  ,TotalWeeks
  ,TotalHours
  ,FullCourseFee
  ,CourseDescription
)
SELECT CourseCode, CourseTitle, TotalWeeks, TotalHours, FullCourseFee, CourseDescription
FROM LSP_stage..Courses15
UNION
SELECT CourseCode, CourseTitle, TotalWeeks, TotalHours, FullCourseFee, CourseDescription
FROM LSP_stage..Courses19


--Room
INSERT INTO LSP_dp..Room
(
  RoomName
  ,Capacity
)
SELECT RoomName, Capacity
FROM LSP_stage..Rooms15
UNION
SELECT RoomName, Capacity
FROM LSP_stage..Rooms19


--Term
SET IDENTITY_INSERT Term ON
INSERT INTO LSP_dp..Term
(
  TermID
  ,TermCode
  ,TermName
  ,CalendarYear
  ,AcademicYear
)
SELECT TermID, TermCode, TermName, CalendarYear, AcademicYear
FROM LSP_stage..Terms15
UNION
SELECT TermID, TermCode, TermName, CalendarYear, AcademicYear
FROM LSP_stage..Terms19
SET IDENTITY_INSERT Term OFF


--Person
SET IDENTITY_INSERT Person ON
INSERT INTO LSP_dp..Person
(
  PersonID
  ,LastName
  ,FirstName
  ,MiddleName
  ,Gender
  ,Phone
  ,Email
)
SELECT PersonID, LastName, FirstName, MiddleName, Gender, Phone, Email
FROM LSP_stage..Persons15
UNION
SELECT PersonID, LastName, FirstName, MiddleName, Gender, Phone, Email
FROM LSP_stage..Persons19
SET IDENTITY_INSERT Person OFF


--Faculty
INSERT INTO LSP_dp..Faculty
(
  FacultyFirstName
  ,FacultyLastName
  ,FacultyEmail
  ,PrimaryPhone
  ,AlternativePhone
  ,FacultyAddressLine
  ,FacultyCity
  ,FacultyState
  ,FacultyPostalCode
)
SELECT FacultyFirstName, FacultyLastName, FacultyEmail, PrimaryPhone, AlternatePhone, FacultyAddressLine, FacultyCity, FacultyState, FacultyPostalCode
FROM LSP_stage..Faculty15
UNION
SELECT FacultyFirstName, FacultyLastName, FacultyEmail, PrimaryPhone, AlternatePhone, FacultyAddressLine, FacultyCity, FacultyState, FacultyPostalCode
FROM LSP_stage..Faculty19



------------- FOREIGN KEYS INSERT -------------

--Section
SET IDENTITY_INSERT Section ON
INSERT INTO LSP_dp..Section
(
  SectionID
  ,CourseID
  ,TermID
  ,RoomID
  ,StartDate
  ,EndDate
  ,Days
  ,SectionStatus
)
SELECT SectionID, C.CourseID, TermID, R.RoomID, StartDate, EndDate, Days, SectionStatus
FROM LSP_stage..[Sections SU11-SU15] S
LEFT JOIN Room R ON R.RoomName = S.RoomName
LEFT JOIN Course C ON C.CourseCode = S.CourseCode
UNION
SELECT SectionID, C.CourseID, TermID, R.RoomID, StartDate, EndDate, Days, SectionStatus
FROM LSP_stage..[Sections FA15-SU19] S
LEFT JOIN Room R ON R.RoomName = S.RoomName
LEFT JOIN Course C ON C.CourseCode = S.CourseCode
SET IDENTITY_INSERT Section OFF



--Address
INSERT INTO LSP_dp..Address
(
  PersonID
  ,AddressType
  ,AddressLine
  ,City
  ,State
  ,PostalCode
  ,Country
)
SELECT PersonID, 'home', AddressLine, City, State, PostalCode, NULL
FROM LSP_stage..Persons15 P
WHERE AddressLine IS NOT NULL
UNION
SELECT PersonID, 'home', AddressLine, City, State, PostalCode, NULL
FROM LSP_stage..Persons19 P
WHERE AddressLine IS NOT NULL


--ClassList
INSERT INTO LSP_dp..ClassList
(
  SectionID
  ,PersonID
  ,EnrollmentStatus
  ,TuitionAmount
  ,Grade
)
SELECT SectionID, PersonID, EnrollmentStatus, TuitionAmount, Grade
FROM LSP_stage..[Classlist SU11-SU15] C
UNION
SELECT SectionID, PersonID, EnrollmentStatus, TuitionAmount, Grade
FROM LSP_stage..[ClassList FA15-SU19] C


--FacultyPayment
INSERT INTO LSP_dp..FacultyPayment
(
  FacultyID
  ,SectionID
  ,PrimaryInstructor
  ,PaymentAmount
)
SELECT F.FacultyID, S.SectionID, 'Y', S.PrimaryPayment
FROM LSP_stage..[Sections SU11-SU15] S
JOIN Faculty F ON CONCAT(LEFT(FacultyFirstName,1), '. ',FacultyLastName) = S.PrimaryInstructor
UNION
SELECT F.FacultyID, S.SectionID, 'Y', S.PrimaryPayment
FROM LSP_stage..[Sections FA15-SU19] S
JOIN Faculty F ON CONCAT(LEFT(FacultyFirstName,1), '. ',FacultyLastName) = S.PrimaryInstructor
UNION
SELECT F.FacultyID, S.SectionID, 'N', S.SecondaryPayment
FROM LSP_stage..[Sections SU11-SU15] S
JOIN Faculty F ON CONCAT(LEFT(FacultyFirstName,1), '. ',FacultyLastName) = S.SecondaryInstructor
UNION
SELECT F.FacultyID, S.SectionID, 'N', S.SecondaryPayment
FROM LSP_stage..[Sections FA15-SU19] S
JOIN Faculty F ON CONCAT(LEFT(FacultyFirstName,1), '. ',FacultyLastName) = S.SecondaryInstructor




--------ADDITIONAL DATABASE OBJECTS (Views - Stored Procedures) --------
--1.
GO
CREATE VIEW CourseRevenue_v AS
SELECT
    C.CourseCode
    ,C.CourseTitle
    ,COUNT(DISTINCT S.SectionID) AS SectionCount
    ,SUM(CL.TuitionAmount) AS [TotalRevenue]
    ,CAST(SUM(CL.TuitionAmount)/CAST(COUNT(DISTINCT S.SectionID) AS numeric) AS numeric(9,2)) AS [AverageRevenue]
FROM Course C
LEFT JOIN Section S ON S.CourseID = C.CourseID AND S.SectionStatus != 'CN'
LEFT JOIN ClassList CL ON CL.SectionID = S.SectionID
GROUP BY C.CourseCode, C.CourseTitle


--2.
GO
CREATE VIEW AnnualRevenue_v AS
WITH CTE AS(
SELECT
    S.SectionID
    ,SUM(CL.TuitionAmount) AS [TotalTuition]
FROM Section S
JOIN ClassList CL ON CL.SectionID = S.SectionID
GROUP BY S.SectionID
)
SELECT
    T.AcademicYear
    ,SUM(CTE.TotalTuition) AS TotalTuition
    ,SUM(FP.PaymentAmount) AS TotalFacultyPayments
FROM Course C
JOIN Section S ON S.CourseID = C.CourseID
JOIN Term T ON T.TermID = S.TermID
LEFT JOIN FacultyPayment FP ON FP.SectionID = S.SectionID
LEFT JOIN CTE ON CTE.SectionID = S.SectionID
GROUP BY T.AcademicYear


--3.
GO
CREATE PROC StudentHistory_p @PersonPrimaryKey int AS
SELECT
    CONCAT(P.FirstName, ' ', P.LastName) AS [StudentName]
    ,S.SectionID
    ,C.CourseCode
    ,C.CourseTitle
    ,CONCAT(F.FacultyFirstName, ' ', F.FacultyLastName) AS [FacultyName]
    ,T.TermCode
    ,S.StartDate
    ,CL.TuitionAmount
    ,CL.Grade
FROM Person P
JOIN ClassList CL ON CL.PersonID = P.PersonID
JOIN Section S ON S.SectionID = CL.SectionID
JOIN Term T ON T.TermID = S.TermID
JOIN Course C ON C.CourseID = S.CourseID
JOIN FacultyPayment FP ON FP.SectionID = S.SectionID AND FP.PrimaryInstructor = 'Y'
JOIN Faculty F ON F.FacultyID = FP.FacultyID
WHERE P.PersonID = @PersonPrimaryKey
ORDER BY StartDate


--4.
GO
CREATE PROC InsertPerson_p
    @PersonFirstName varchar(35)
    ,@PersonLastName varchar(50)
    ,@AddressAddressType varchar(10)
    ,@AddressAddressLine varchar(50)
    ,@AddressCity varchar(25)
AS
CREATE Table #Person(PersonID int)
INSERT INTO Person(FirstName, LastName)
OUTPUT inserted.PersonID INTO #Person
VALUES(@PersonFirstName, @PersonLastName)

INSERT INTO Address(AddressType, AddressLine, City, PersonID)
SELECT @AddressAddressType, @AddressAddressLine, @AddressCity, #Person.PersonID
FROM #Person






---------EXECUTE CODE FOR SCREENSHOTS--------
GO
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



