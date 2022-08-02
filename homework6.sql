--Derek Podimatis

USE master
IF DB_ID('MyDB_DerekPodimatis') IS NOT NULL
BEGIN
    ALTER DATABASE MyDB_DerekPodimatis SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE MyDB_DerekPodimatis SET ONLINE;
    DROP DATABASE MyDB_DerekPodimatis;
END


--1
CREATE DATABASE MyDB_DerekPodimatis
GO
USE MyDB_DerekPodimatis

--2
SELECT *
INTO Users
FROM Chinook.dbo.Customer
USE MyDB_DerekPodimatis


--3
DELETE Users
WHERE CustomerId % 2 != 0


--4
UPDATE Users
SET Company = CASE
    WHEN Email LIKE '%gmail%' THEN 'Google'
    WHEN Email LIKE '%yahoo%' THEN 'Yahoo!'
    ELSE Company
    END


--5
EXEC sp_rename 'Users.CustomerId', 'UserId', 'COLUMN'


--6
ALTER TABLE Users
ADD CONSTRAINT pk_Users PRIMARY KEY (UserId)


--7
CREATE TABLE Address (
    AddressId int IDENTITY(1,1) PRIMARY KEY
    ,AddressType varchar(10)
    ,AddressLine1 varchar(50)
    ,City varchar(30)
    ,State varchar(2)
    ,UserId int
    ,CreateDate datetime DEFAULT GETDATE()
)


--8
ALTER TABLE Address
ADD CONSTRAINT uc_AddressType UNIQUE (UserId, AddressType)


--9
ALTER TABLE Address
ADD CONSTRAINT fk_UserAddress FOREIGN KEY (UserId)
    REFERENCES Users(UserId)


--10
INSERT INTO Address (AddressType, AddressLine1, City, State, UserId)
VALUES ('home', '111 Elm St.', 'Los Angeles', 'CA', 2)
,('home', '222 Palm Ave.', 'San Diego', 'CA', 4)
,('work', '333 Oak Ln.', 'La Jolla', 'CA', 4)


--11
SELECT *
FROM Users

SELECT *
FROM Address