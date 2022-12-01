-- ADDRESS
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[AddressType] [varchar](10) NULL,
	[AddressLine] [varchar](50) NOT NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](10) NULL,
	[PostalCode] [varchar](15) NULL,
	[Country] [varchar](25) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Address] ADD PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO



--CLASSLIST
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassList](
	[ClassListID] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[Grade] [varchar](2) NULL,
	[EnrollmentStatus] [char](2) NULL,
	[TuitionAmount] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClassList] ADD PRIMARY KEY CLUSTERED 
(
	[ClassListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClassList]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[ClassList]  WITH CHECK ADD FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO



--COURSE
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [varchar](10) NULL,
	[CourseTitle] [varchar](60) NULL,
	[TotalWeeks] [int] NULL,
	[TotalHours] [numeric](9, 2) NULL,
	[FullCourseFee] [numeric](9, 2) NULL,
	[CourseDescription] [varchar](500) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Course] ADD PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--FACULTY
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[FacultyID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyFirstName] [varchar](35) NULL,
	[FacultyLastName] [varchar](50) NULL,
	[FacultyEmail] [varchar](100) NULL,
	[PrimaryPhone] [varchar](25) NULL,
	[AlternativePhone] [varchar](25) NULL,
	[FacultyAddressLine] [varchar](50) NULL,
	[FacultyCity] [varchar](25) NULL,
	[FacultyState] [char](2) NULL,
	[FacultyPostalCode] [char](5) NULL,
	[FacultyCountry] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Faculty] ADD PRIMARY KEY CLUSTERED 
(
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--FACULTYPAYMENT
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacultyPayment](
	[FacultyPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyID] [int] NULL,
	[SectionID] [int] NULL,
	[PrimaryInstructor] [char](1) NOT NULL,
	[PaymentAmount] [numeric](9, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FacultyPayment] ADD PRIMARY KEY CLUSTERED 
(
	[FacultyPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FacultyPayment]  WITH CHECK ADD FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[FacultyPayment]  WITH CHECK ADD FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO



--PERSON
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](50) NULL,
	[FirstName] [varchar](35) NULL,
	[MiddleName] [varchar](35) NULL,
	[Gender] [char](1) NULL,
	[Phone] [varchar](20) NULL,
	[Email] [varchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Person] ADD PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--ROOM
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomName] [varchar](50) NULL,
	[Capacity] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Room] ADD PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--SECTION
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [int] IDENTITY(10000,1) NOT NULL,
	[CourseID] [int] NOT NULL,
	[TermID] [int] NOT NULL,
	[RoomID] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Days] [varchar](50) NULL,
	[SectionStatus] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Section] ADD PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD FOREIGN KEY([TermID])
REFERENCES [dbo].[Term] ([TermID])
GO



--TERM
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Term](
	[TermID] [int] IDENTITY(1,1) NOT NULL,
	[TermCode] [char](4) NULL,
	[TermName] [varchar](20) NULL,
	[CalendarYear] [smallint] NULL,
	[AcademicYear] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Term] ADD PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--VIEWS, PROCEDURES

--1.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CourseRevenue_v] AS
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AnnualRevenue_v] AS
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[StudentHistory_p] @PersonPrimaryKey int AS
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertPerson_p]
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


