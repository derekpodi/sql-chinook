USE master 
GO


-------- CREATE DATABASES --------
CREATE DATABASE LSP_stage
GO

CREATE DATABASE LSP_dp
GO

USE LSP_dp 
GO


/*
-------- CREATE TABLES --------

CREATE TABLE Section(
    SectionID int PRIMARY KEY
    ,CourseID int FOREIGN KEY REFERENCES Course(CourseID)
    ,TermID int FOREIGN KEY REFERENCES Term(TermID)
    ,RoomID int FOREIGN KEY REFERENCES Room(RoomID)
)

CREATE TABLE Course(
    CourseID int PRIMARY KEY
)

CREATE TABLE Room(
    RoomID int PRIMARY KEY
)

CREATE TABLE Term(
    TermID int PRIMARY KEY
)

CREATE TABLE ClassList(
    ClassListID int PRIMARY KEY
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID)
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID)
)

CREATE TABLE Person(
    PersonID int PRIMARY KEY
)

CREATE TABLE Address(
    AddressID int PRIMARY KEY
    ,PersonID int FOREIGN KEY REFERENCES Person(PersonID)
)

CREATE TABLE FacultyPayment(
    FacultyPaymentID int PRIMARY KEY
    ,FacultyID int FOREIGN KEY REFERENCES Faculty(FacultyID)
    ,SectionID int FOREIGN KEY REFERENCES Section(SectionID)
)

CREATE TABLE Faculty(
    FacultyID int PRIMARY KEY
)

*/



/*
--------ADDITIONAL DATABASE OBJECTS--------
--1.
CREATE VIEW CourseRevenue_v AS
SELECT
    [Course Code]
    ,[Course Title]
    ,[Count of Sections]
    ,[Total Gross Revenue]
    ,[AVG Revenue Per Section]
FROM [TABLE NAME]

--2.
CREATE VIEW AnnualRevenue_v AS
SELECT
    [Gross Revenue from tuition]
    ,[faculty payments fr each academic year]
FROM [TABLE NAME]

--3.
CREATE PROC StudentHistory_p @PersonPrimaryKey int AS
SELECT
    [Student Name]
    ,[SectionID]
    ,[Course Code]
    ,[CourseTitle]
    ,[Primary Instructor Name]
    ,[Term Code]
    ,[Start Date]
    ,[Tuition Paid]
    ,[Grade]
FROM [TABLE NAME]
WHERE PersonID = @PersonPrimaryKey

--4.
CREATE PROC InsertPerson_p
    @PersonFirstName varchar(50)
    ,@PersonLastName varchar(50)
    ,@AddressAddressType varchar(50)
    ,@AddressAddressLine varchar(50)
    ,@AddressCity varchar(50) AS
BEGIN
    INSERT INTO Person(FirstName, LastName)
    VALUES(@PersonFirstName, @PersonLastName);

    INSERT INTO Address(AddressType, AddressLine, City)
    VALUES(@AddressAddressType, @AddressAddressLine, @AddressCity);

END

*/



/*
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

*/




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




--Script DB - ERD
--https://stackoverflow.com/questions/59852790/script-database-with-azure-data-studio
--https://www.sqlshack.com/generate-data-scripts-using-ssms-and-azure-data-studio/
--https://stackoverflow.com/questions/53293349/azure-data-studio-schema-diagram
--https://www.sqlshack.com/sql-server-data-import-using-azure-data-studio/

