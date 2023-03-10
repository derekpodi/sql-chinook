--Derek Podimatis

/*
USE stackoverflow;

CHECKPOINT
DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
*/


/*
1. Optimize query for Votes on July 4th, 2009
       Estimated Subtree Cost Before: 45.6269
       Estimated Subtree Cost After:0.026038

SELECT Id, CreationDate
FROM Votes
WHERE CreationDate = '7/4/2009'
*/
--1
CREATE NONCLUSTERED INDEX ix_Votes_CreationDate
       ON Votes(CreationDate)


/*
2. Display users from San Diego with a reputation greater than 10,000.
       Estimated Subtree Cost Before: 5.79558
       Estimated Subtree Cost After:  0.0032946

SELECT Id, DisplayName, Reputation, Location
FROM Users
WHERE Reputation > 10000
       AND Location = 'San Diego, CA'
*/
--2
CREATE NONCLUSTERED INDEX ix_Users_Reputation_Location
       ON Users(Reputation, Location)
       INCLUDE(DisplayName)


/*
3. Display posts tagged with "sql" that have more than 1,000,000 views.
       Restriction: The Body column cannot be used in an INCLUDE clause.
       Estimated Subtree Cost Before: 81.3454
       Estimated Subtree Cost After:   0.190825

SELECT Id, Title, Body, CreationDate, Tags, ViewCount
FROM Posts
WHERE Tags LIKE '%sql%'
       AND ViewCount > 1000000
*/
--3
CREATE NONCLUSTERED INDEX ix_Posts_ViewCount_Tags
       ON Posts(ViewCount, Tags)



/*
4. Display posts by Justin Grant ordered by creation date.
       Show whether they are questions or answers.
       Estimated Subtree Cost Before: 107.552
       Estimated Subtree Cost After:    0.0420264

SELECT U.DisplayName, U.Location, P.Title, P.CreationDate, PT.Type
FROM Posts P
JOIN PostTypes PT ON PT.ID = P.PostTypeId
JOIN Users U ON U.ID = P.OwnerUserId
WHERE U.DisplayName = 'Justin Grant'
ORDER BY P.CreationDate
*/
--4
CREATE NONCLUSTERED INDEX ix_Posts_OwnerUserId_CreationDate
       ON Posts(OwnerUserId, CreationDate)
       INCLUDE(Title, PostTypeId)

CREATE NONCLUSTERED INDEX ix_Users_DisplayName_Location
       ON Users(DisplayName, Location)



/*
5. Display badges for Justin Grant. Group by badge name and order by count. 
       Estimated Subtree Cost Before: 17.0679
       Estimated Subtree Cost After:   0.0300365

SELECT U.DisplayName, U.Location, B.Name AS BadgeName, COUNT(B.Name) AS Total
FROM Users U
JOIN Badges B ON B.UserId = U.Id
WHERE U.DisplayName = 'Justin Grant'
GROUP BY U.DisplayName, U.Location, B.Name
ORDER BY Total DESC, BadgeName
*/
--5
--NOTE: Use the index from question #4: ix_Users_DisplayName_Location  
CREATE NONCLUSTERED INDEX ix_Badges_UserId_Name
       ON Badges(UserId, Name)



/*
6. Display TOP 100 comments by score.
       Restriction: The Text column cannot be used in an INCLUDE clause.
       Estimated Subtree Cost Before: 763.553
       Estimated Subtree Cost After:    0.335262

SELECT TOP 100 *
FROM Comments
ORDER BY Score DESC
*/
--6
CREATE NONCLUSTERED INDEX ix_Comments_Score
       ON Comments(Score)





/*
7. Display posts with a LastActivityDate greater than 1/1/2018.
       Restriction: The index can only contain dates greater than 1/1/2018.
       Estimated Subtree Cost Before: 86.5618
       Estimated Subtree Cost After:   0.0684346

SELECT ID, Body, Title, CreationDate, LastActivityDate
FROM Posts
WHERE LastActivityDate > '1/1/2018'
ORDER BY LastActivityDate
*/
--7
CREATE NONCLUSTERED INDEX filter_ix_Posts_LastActivityDate
       ON Posts(LastActivityDate)
       INCLUDE(Body, Title, CreationDate)
       WHERE LastActivityDate >= '1/1/2018'             --Need >= for Index Seek





/*
8. Pull all posts by Justin Grant. Include the parent title for all answers.
       Note: You can use Body and Title in an INCLUDE,
       see if the performance improvement is worth the space used.
       Estimated Subtree Cost Before: 112.094
       Estimated Subtree Cost After:    0.565453

SELECT U.DisplayName, P.Id, PT.Type, COALESCE(P.Title,PP.Title) AS Title, P.CreationDate, P.Body
FROM Posts P
LEFT JOIN Posts PP ON PP.Id = P.ParentId
JOIN Users U ON U.ID = P.OwnerUserId
JOIN PostTypes PT ON PT.Id = P.PostTypeId
WHERE U.DisplayName = 'Justin Grant'
*/
--8
--NOTE: Use the index from question #4: ix_Users_DisplayName_Location  
CREATE NONCLUSTERED INDEX ix_Posts_OwnerUserId
       ON Posts(OwnerUserId)
       --INCLUDE(Title, Body, CreationDate, PostTypeId, ParentId)

--NOTE: Performance boost likely not worth the space used with the INCLUDE columns



/*
9. Display titles of posts that have been linked to more than 100 times by other posts.
       Estimated Subtree Cost Before: 90.7207
       Estimated Subtree Cost After:  10.19

SELECT P.Title AS SourceTitle, count(*) AS TotalLinks
FROM PostLinks PL
JOIN Posts P ON  P.Id = PL.RelatedPostId
       AND P.PostTypeId = 1 --Only questions have titles.
GROUP BY P.Title
HAVING count(*) > 100
ORDER BY count(*) DESC
*/
--9
CREATE NONCLUSTERED INDEX ix_PostLinks_RelatedPostId
       ON PostLinks(RelatedPostId)

CREATE NONCLUSTERED INDEX ix_Posts_PostTypeId
       ON Posts(PostTypeId)
       INCLUDE(Title)



/*
10. Find posts by Justin Grant that had someone vote as a "Favorite".
       Estimated Subtree Cost Before: 203.804
       Estimated Subtree Cost After: 0.341001

SELECT P.Title, U.DisplayName
FROM Posts P
JOIN Users U ON U.Id = P.OwnerUserId
WHERE U.DisplayName = 'Justin Grant'
AND EXISTS(SELECT *
    FROM Votes V
    JOIN VoteTypes VT ON VT.Id = V.VoteTypeId
    WHERE VT.Name = 'Favorite'
    AND P.Id = V.PostId)
*/
--10
--NOTE: Use the index from question #4: ix_Users_DisplayName_Location  
--NOTE: Use the index from question #4: ix_Posts_OwnerUserId_CreationDate 
CREATE NONCLUSTERED INDEX ix_Votes_PostId
       ON Votes(PostId)
       INCLUDE(VoteTypeId)




/*
11. BONUS QUESTION: Can this query be optimized? Why or why not?
       I didn’t cover this in the lecture, so an internet search may help you find the answer.

SELECT Title
FROM Posts
WHERE Title LIKE '%sql%'
*/
--11
--No, the wildcard '%' will initiate a full table/index scan, not a table/index seek. It will not be able to take advantage of any index that you have made.


