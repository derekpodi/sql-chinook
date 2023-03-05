--Derek Podimatis

USE Chinook;

/*
1. Optimize query for Votes on July 4th, 2009
       Estimated Subtree Cost Before: 45.6269
       Estimated Subtree Cost After:0.026038
*/
SELECT Id, CreationDate
FROM Votes
WHERE CreationDate = '7/4/2009'


--1








/*
2. Display users from San Diego with a reputation greater than 10,000.
       Estimated Subtree Cost Before: 5.79558
       Estimated Subtree Cost After:  0.0032946
*/
SELECT Id, DisplayName, Reputation, Location
FROM Users
WHERE Reputation > 10000
       AND Location = 'San Diego, CA'

--2







/*
3. Display posts tagged with "sql" that have more than 1,000,000 views.
       Restriction: The Body column cannot be used in an INCLUDE clause.
       Estimated Subtree Cost Before: 81.3454
       Estimated Subtree Cost After:   0.190825
*/
SELECT Id, Title, Body, CreationDate, Tags, ViewCount
FROM Posts
WHERE Tags LIKE '%sql%'
       AND ViewCount > 1000000

--3








/*
4. Display posts by Justin Grant ordered by creation date.
       Show whether they are questions or answers.
       Estimated Subtree Cost Before: 107.552
       Estimated Subtree Cost After:    0.0420264
*/
SELECT U.DisplayName, U.Location, P.Title, P.CreationDate, PT.Type
FROM Posts P
JOIN PostTypes PT ON PT.ID = P.PostTypeId
JOIN Users U ON U.ID = P.OwnerUserId
WHERE U.DisplayName = 'Justin Grant'
ORDER BY P.CreationDate

--4








/*
5. Display badges for Justin Grant. Group by badge name and order by count. Estimated Subtree Cost Before: 17.0679
       Estimated Subtree Cost After:   0.0300365
*/
SELECT U.DisplayName, U.Location, B.Name AS BadgeName, COUNT(B.Name) AS Total
FROM Users U
JOIN Badges B ON B.UserId = U.Id
WHERE U.DisplayName = 'Justin Grant'
GROUP BY U.DisplayName, U.Location, B.Name
ORDER BY Total DESC, BadgeName


--5











