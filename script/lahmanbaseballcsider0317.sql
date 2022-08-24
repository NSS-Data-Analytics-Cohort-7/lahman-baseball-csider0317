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
    
    
