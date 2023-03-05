--Derek Podimatis

--cd ./Documents/UCSD Extension/Advanced Sql/Lesson 5
--sudo docker exec -it azuresqledge  mkdir /var/opt/mssql/backup
--sudo docker cp StackOverFlow.bak azuresqledge:/var/opt/mssql/backup

/*

SQL Server caches the results of a query in memory after you run it the first time. This means the 2nd time you run it the results may display faster. This is a trick. SQL will have to work just as hard to pull the results once the memory cache clears itself. You can manually clear the memory cache yourself by executing the following code:
CHECKPOINT
DBCC DROPCLEANBUFFERS
This will force the server to pull the data from disk, and allow you to see the true performance of your queries.
I didn’t cover this in class but executing the following code will give you additional statistics on the queries you executed. It’s another way of seeing the before and after results from your index creation.
SET STATISTICS IO ON
*/
--https://database.guide/how-to-view-the-query-execution-plan-in-azure-data-studio-sql-server/

USE stackoverflow;

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









/*
6. Display TOP 100 comments by score.
       Restriction: The Text column cannot be used in an INCLUDE clause.
       Estimated Subtree Cost Before: 763.553
       Estimated Subtree Cost After:    0.335262
*/
SELECT TOP 100 *
FROM Comments
ORDER BY Score DESC


--6









/*
7. Display posts with a LastActivityDate greater than 1/1/2018.
       Restriction: The index can only contain dates greater than 1/1/2018.
       Estimated Subtree Cost Before: 86.5618
       Estimated Subtree Cost After:   0.0684346
*/
SELECT ID, Body, Title, CreationDate, LastActivityDate
FROM Posts
WHERE LastActivityDate > '1/1/2018'
ORDER BY LastActivityDate


--7










/*
8. Pull all posts by Justin Grant. Include the parent title for all answers.
       Note: You can use Body and Title in an INCLUDE,
       see if the performance improvement is worth the space used.
       Estimated Subtree Cost Before: 112.094
       Estimated Subtree Cost After:    0.565453
*/
SELECT U.DisplayName, P.Id, PT.Type, COALESCE(P.Title,PP.Title) AS Title, P.CreationDate
, P.Body
FROM Posts P
LEFT JOIN Posts PP ON PP.Id = P.ParentId
JOIN Users U ON U.ID = P.OwnerUserId
JOIN PostTypes PT ON PT.Id = P.PostTypeId
WHERE U.DisplayName = 'Justin Grant'


--8









/*
9. Display titles of posts that have been linked to more than 100 times by other posts.
       Estimated Subtree Cost Before: 90.7207
       Estimated Subtree Cost After:  10.19
*/
SELECT P.Title AS SourceTitle, count(*) AS TotalLinks
FROM PostLinks PL
JOIN Posts P ON  P.Id = PL.RelatedPostId
       AND P.PostTypeId = 1 --Only questions have titles.
GROUP BY P.Title
HAVING count(*) > 100
ORDER BY count(*) DESC


--9








/*
10. Find posts by Justin Grant that had someone vote as a "Favorite".
       Estimated Subtree Cost Before: 203.804
       Estimated Subtree Cost After: 0.341001
*/
SELECT P.Title, U.DisplayName
FROM Posts P
JOIN Users U ON U.Id = P.OwnerUserId
WHERE U.DisplayName = 'Justin Grant'
AND EXISTS(SELECT *
    FROM Votes V
    JOIN VoteTypes VT ON VT.Id = V.VoteTypeId
    WHERE VT.Name = 'Favorite'
    AND P.Id = V.PostId)


--10









/*
11. BONUS QUESTION: Can this query be optimized? Why or why not?
       I didn’t cover this in the lecture, so an internet search may help you find the answer.
*/
SELECT Title
FROM Posts
WHERE Title LIKE '%sql%'


--11


