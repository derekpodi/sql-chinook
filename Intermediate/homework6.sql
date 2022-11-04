
-- USE DCL Language to Create the Logins and Permissions if not possible with SQL Edge
USE Chinook
/*
--Create User Accounts
CREATE LOGIN TestLogin1 WITH PASSWORD = 'test';
CREATE USER TestLogin1 FOR LOGIN TestLogin1;

CREATE LOGIN TestLogin2 WITH PASSWORD = 'test';
CREATE USER TestLogin2 FOR LOGIN TestLogin2;

CREATE LOGIN TestLogin3 WITH PASSWORD = 'test';
CREATE USER TestLogin3 FOR LOGIN TestLogin3;

CREATE LOGIN TestLogin4 WITH PASSWORD = 'test';
CREATE USER TestLogin4 FOR LOGIN TestLogin4;

CREATE LOGIN TestLogin5 WITH PASSWORD = 'test';
CREATE USER TestLogin5 FOR LOGIN TestLogin5;


--Create New DB Role in Chinook
---https://www.sqlservertutorial.net/sql-server-administration/sql-server-create-role/--
CREATE ROLE [Read and Update];
GRANT SELECT, INSERT, UPDATE, DELETE 
ON SCHEMA::[Read and Update]
TO [Read and Update];


--Create New Schema in Chinook
CREATE SCHEMA dev;

SELECT * 
INTO dev.Employee 
FROM Employee

SELECT * 
INTO dev.Customer
FROM Customer


--Add User Accounts to Chinook and Assign Permissions
ALTER ROLE db_owner ADD MEMBER TestLogin1;

ALTER ROLE db_datareader ADD MEMBER TestLogin2;
ALTER ROLE db_datawriter ADD MEMBER TestLogin2;
--PERMISSIONS:DENY SELECT on BirthDate Column in Employee table.
--Permissions: Assign as the schema owner to the “dev” schema
--Permissions: “Read and Update” Role
--Permissions: “Read and Update” Role, DENY SELECT, INSERT, UPDATE and DELETE permissions to Employee table


--Login With Diffrent TestLogin Accounts


*/


/*
--UNCOMMENT, EXEXCUTE SELECT STATEMENTS, AND THEN SUBMIT SCREENSHOT --

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
*/