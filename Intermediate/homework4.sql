--Derek Podimatis

USE Chinook;

--1
SELECT
    column1 AS Zipcode
    ,CONCAT(column2, column3) AS ZipType
    ,column4 AS City
    ,LEFT(column5,2) AS State
    ,SUBSTRING(column5,3,LEN(column5)) AS County
    ,column6 AS Country
    ,column7 AS Latitude
    ,column8 AS Longitude
    ,column9 AS Population
FROM zip_code_ragged_right
WHERE LEFT(column5,2) = 'CA' AND column9 > 50000
ORDER BY column9 DESC


SELECT
    COUNT(*)
FROM zip_code_ragged_right
WHERE LEFT(column5,2) = 'CA' AND column9 > 50000
        --169   



--2
SELECT TOP 1
    column1 AS Zipcode
    ,column4 AS City
    ,LEFT(column5,2) AS State
    ,SUBSTRING(column5,3,LEN(column5)) AS County
    ,column6 AS Country
    ,column9 AS Population
FROM zip_code_ragged_right
ORDER BY column9 DESC


SELECT TOP 1
    column1 AS Zipcode
FROM zip_code_ragged_right
ORDER BY column9 DESC
        --60629


--3
SELECT *
FROM [Licensed Healthcare Facilities in California (OSHPD)]
WHERE COUNTY_CODE = 37 AND FACILITY_STATUS_DESC = 'Open' AND LICENSE_CATEGORY_DESC = 'General Acute Care Hospital'


SELECT COUNT(*)
FROM [Licensed Healthcare Facilities in California (OSHPD)]
WHERE COUNTY_CODE = 37 AND FACILITY_STATUS_DESC = 'Open' AND LICENSE_CATEGORY_DESC = 'General Acute Care Hospital'
        --26


--4
SELECT *
FROM [Licensed Healthcare Facilities in California (OSHPD)]
WHERE ER_SERVICE_LEVEL_DESC = 'Emergency - Comprehensive'
    OR CAST(REPLACE(TOTAL_NUMBER_BEDS,',', '') AS int) > 500
ORDER BY TOTAL_NUMBER_BEDS DESC

SELECT COUNT(*)
FROM [Licensed Healthcare Facilities in California (OSHPD)]
WHERE ER_SERVICE_LEVEL_DESC = 'Emergency - Comprehensive'
    OR CAST(REPLACE(TOTAL_NUMBER_BEDS,',', '') AS int) > 500
        --30


--5
SELECT *
FROM yob1968
WHERE LEFT(column1, 1) = 'S' AND column3 > 7500


SELECT COUNT(*)
FROM yob1968
WHERE LEFT(column1, 1) = 'S' AND column3 > 7500
        --8





--------------- SELECT ALL ----------
SELECT *
FROM zip_code_ragged_right

SELECT *
FROM [Licensed Healthcare Facilities in California (OSHPD)]

SELECT *
FROM yob1968