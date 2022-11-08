
-- USE DCL Language to Create the Logins and Permissions if not possible with SQL Edge

USE Chinook

--Create User Accounts
CREATE LOGIN TestLogin1 WITH PASSWORD = 'MyPassword@';
CREATE USER TestLogin1 FOR LOGIN TestLogin1;

CREATE LOGIN TestLogin2 WITH PASSWORD = 'MyPassword@';
CREATE USER TestLogin2 FOR LOGIN TestLogin2;

CREATE LOGIN TestLogin3 WITH PASSWORD = 'MyPassword@';
CREATE USER TestLogin3 FOR LOGIN TestLogin3;

CREATE LOGIN TestLogin4 WITH PASSWORD = 'MyPassword@';
CREATE USER TestLogin4 FOR LOGIN TestLogin4;

CREATE LOGIN TestLogin5 WITH PASSWORD = 'MyPassword@';
CREATE USER TestLogin5 FOR LOGIN TestLogin5;

GO
--Create New DB Role in Chinook
---https://www.sqlservertutorial.net/sql-server-administration/sql-server-create-role/--
CREATE ROLE [Read and Update];
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [Read and Update];
GO

--Create New Schema in Chinook
CREATE SCHEMA dev AUTHORIZATION TestLogin3;
GO

SELECT * 
INTO dev.Employee 
FROM Employee

SELECT * 
INTO dev.Customer
FROM Customer


--Add User Accounts to Chinook and Assign Permissions
--https://stackoverflow.com/questions/11086967/how-to-permit-a-sql-server-user-to-insert-update-delete-data-but-not-alter-sche
ALTER ROLE db_owner ADD MEMBER TestLogin1;

ALTER ROLE db_datareader ADD MEMBER TestLogin2;
ALTER ROLE db_datawriter ADD MEMBER TestLogin2;
--GRANT ALTER ON SCHEMA::dbo TO TestLogin2;
--https://www.mssqltips.com/sqlservertip/2124/filtering-sql-server-columns-using-column-level-permissions/
DENY SELECT ON dbo.Employee (BirthDate) TO TestLogin2;           

--Permissions: Assign as the schema owner to the “dev” schema
--GRANT ALTER ON SCHEMA::dev TO TestLogin3;

ALTER ROLE [Read and Update] ADD MEMBER TestLogin4;

ALTER ROLE [Read and Update] ADD MEMBER TestLogin5;
--GRANT ALTER ON SCHEMA::dbo TO TestLogin5;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Employee TO TestLogin5;


--Login With Diffrent TestLogin Accounts
--https://learn.microsoft.com/en-us/sql/t-sql/statements/execute-as-transact-sql?redirectedfrom=MSDN&view=sql-server-ver16
EXECUTE AS LOGIN = 'TestLogin1'; 
SELECT *
INTO #Customer_Temp 
FROM Customer
REVERT;  

EXECUTE AS LOGIN = 'TestLogin2'; 
SELECT BirthDate
FROM Employee
REVERT;

EXECUTE AS LOGIN = 'TestLogin3'; 
SELECT * FROM dev.Employee
SELECT * FROM dev.Customer
REVERT;

EXECUTE AS LOGIN = 'TestLogin4'; 
UPDATE #Customer_Temp
SET FirstName = 'Brian'
WHERE #Customer_Temp.SupportRepId = 1
CREATE TABLE Example (number int);
REVERT;

EXECUTE AS LOGIN = 'TestLogin5'; 
SELECT * FROM Employee
REVERT;


--Drop Users/Logins/Role/Schema

DROP USER TestLogin1;
DROP LOGIN TestLogin1;

DROP USER TestLogin2;
DROP LOGIN TestLogin2;

DROP USER TestLogin3;
DROP LOGIN TestLogin3;

DROP USER TestLogin4;
DROP LOGIN TestLogin4;

DROP USER TestLogin5;
DROP LOGIN TestLogin5;

DROP TABLE dev.Customer
DROP TABLE dev.Employee

DROP ROLE [Read and Update]
DROP SCHEMA dev



---------- EXEC THEN SCREENSHOT RESULT FOR HW -------------
--Role Membership--
SELECT
    user_name(member_principal_id) AS RoleMember ,user_name(role_principal_id) AS RoleName
FROM sys.database_role_members
WHERE user_name(member_principal_id) LIKE 'TestLogin%'
ORDER BY RoleMember

--Schema Owners--
SELECT
    user_name(principal_id) AS SchemaOwner 
    ,name AS SchemaName
FROM sys.schemas
WHERE name = 'dev'

--Object Permissions--
SELECT
    U.name AS UserName
    ,O.name AS TableName
    ,C.name AS ColumnName
    ,permission_name AS PermissionName
    ,state_desc AS StatusName
    ,DB_Name() AS DatabaseName
FROM sys.database_permissions DP
LEFT JOIN sys.columns C ON dp.major_id = C.object_id AND DP.minor_id = C.column_id
LEFT JOIN sys.objects O ON dp.major_id = O.object_id
LEFT JOIN sys.sysusers U ON U.uid = DP.grantee_principal_id
WHERE U.name LIKE 'TestLogin%' OR U.name = 'Read and Update'
ORDER BY UserName
