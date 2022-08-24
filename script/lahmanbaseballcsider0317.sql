1. What range of years for baseball games played does the provided database cover? 

SELECT 
 DISTINCT yearid
FROM teams
1871 through 2016

2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

SELECT
    p.namefirst,
    p.namelast,
    p.height,
    t.name,
    p.playerid,
    a.g_all
 FROM people AS p
 LEFT JOIN appearances as a
 ON p.playerid=a.playerid
 LEFT JOIN teams as t
 ON a.teamid=t.teamid
  WHERE p.playerid='gaedeed01'
 GROUP BY p.namefirst, p.namelast, p.playerid, a.g_all, t.name
 ORDER BY p.height
    
3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?    

--just looking at the table
SELECT *
FROM schools
WHERE schoolstate='TN'


SELECT
    p.namefirst,
    p.namelast,
    cp.schoolid,
    CAST(CAST(SUM(s.salary) AS NUMERIC) AS MONEY)
FROM people as p
LEFT JOIN collegeplaying AS cp
    on p.playerid=cp.playerid
LEFT JOIN salaries as s
ON cp.playerid=s.playerid
WHERE schoolid='vandy'
group by  p.namefirst,
    p.namelast,
    cp.schoolid
HAVING SUM(s.salary)IS NOT NULL
order by CAST(CAST(SUM(s.salary) AS NUMERIC) AS MONEY) DESC

4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.


