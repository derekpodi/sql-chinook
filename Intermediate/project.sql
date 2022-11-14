USE master 
GO

/*
-------- CREATE DATABASE --------

CREATE DATABASE LSP_dp 
USE LSP_dp 
GO
*/

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