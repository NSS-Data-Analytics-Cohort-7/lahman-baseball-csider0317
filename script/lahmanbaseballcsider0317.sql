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
41424	"Battery"
58934	"Infield"
29560	"Outfield"

SELECT
         SUM(po),
        --pos,
    case when pos IN ('SS', '1B', '2B','3B') THEN 'Infield'
    when pos= 'OF' then 'Outfield'
    when pos IN ('P', 'C') then 'Battery'
    ELSE null END as position          
FROM fielding
where yearid='2016'
group by position

5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
2010	7.52	0.98
2000	6.56	1.07
1990	6.15	0.96
1980	5.36	0.81
1970	5.14	0.75
1960	5.72	0.82
1950	4.40	0.84
1940	3.55	0.52
1930	3.32	0.55
1920	2.81	0.40
-- I have zero idea where the ((yearid/10)*10) cme from but adrianne told our breakout room and now it makes sense 
SELECT 
    ((yearid/10)*10) as decade,
    round(round(sum(so),2)/round(sum(g),2),2) as avg_strikeout,
    round(round(sum(hra),2)/round(sum(g),2),2) as avg_homeruns
FROM teams
WHERE ((yearid/10)*10) between 1920 and 2010
group by 1
order by decade desc


select 
    g,
    teamid, 
    yearid
    FROM teams
    where yearid between 1990 and 1999
    group by yearid, teamid, g, 

6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
answer chris owings 
SELECT
b.sb,
b.cs,
 b.sb/b.cs as successful_steals,
--b.cs,--caught stealing
--b.sb, --stolen bases
--yearid 2016
p.namefirst,
p.namelast
from batting as b
join people as p
on b.playerid=p.playerid
where b.yearid=2016 and sb>=20
group by p.namefirst, p.namelast, b.sb, b.cs
order by successful_steals DESC


select
sb,
cs
FROM batting

7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
--answer yankees 
SELECT -- select statement for largest number of wins 
wswin,
max(w)as max_wins, 
-- CASE 
--     when max(w) and wswin='N' THEN 
teamid,
yearid
FROM teams
WHERE wswin='Y' and yearid between '1970' and '2016'
group by teamid, yearid, wswin             
ORDER BY max_wins desc         
--order by max_wins desc
            

SELECT  --least wmount of wins 
wswin,
min(w)as min_wins,
teamid, 
yearid
FROM teams
WHERE wswin='Y' and yearid between '1970' and '2016'
group by teamid, yearid, wswin
order by min_wins

           
with ws_y as(SELECT
wswin,
max(w)as max_wins, 
teamid,
yearid
FROM teams
WHERE  wswin='Y' and yearid between '1970' and '2016'
group by teamid, yearid, wswin             
ORDER BY max_wins desc)
SELECT
    max_wins,
    teamid,
    yearid,
       count(yearid)/46*2 as percent_wins 
    FROM ws_y
    WHERE NOT yearid= '2011' 
    group by max_wins, teamid, yearid
    
    

    

-- with s as (SELECT
--     teamid, 
--     max_wins, 
--     wswins, 
--     yearid
--    FROM teams) as t
  --INNER JOIN 
--1994 has no WS winner
WITH mwins as 
(SELECT
    yearid, max(w) as max_wins
      FROM teams
    where yearid between '1970' and '2016' 
    group by yearid, wswin
    order by yearid)
  
         
 --percentage of most wins that also won the WS 21.73
 -- look at 1981
 
 
 WITH wswin as            
 (WITH maxw as (SELECT
    * 
from ( select
         yearid, 
            wswin, 
                  w,
            row_number () over(partition by yearid order by w desc) as max_wins from teams
     GROUP BY yearid, wswin, w) as s
            WHERE s.max_wins=1 AND yearid BETWEEN '1970' AND '2016')
            SELECT
                SUM(CASE WHEN wswin = 'Y' THEN 1 ELSE 0 END) as win,
                SUM(case when wswin = 'N' THEN 1 ELSE 0 END) as loss                     FROM maxw)
                SELECT 
                
                round(CAST(win as numeric),2)/46*100 as    pecentage_ws_wins_max_game     
                FROM wswin
                group by win
                
           
  8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance. 

-- homegames table
--team bame looks like teamid
--park char vary ex BOS01  year is 1871-05-16 games integer att intger  where games >10

SELECT * from homegames
LIMIT 25

-- top 5
SELECT 
 
    team, 
    park, 
     sum(attendance)/games as avg_attendance
FROM homegames
WHERE year='2016' and games>=10
GROUP BY team, park, games
order by avg_attendance DESC
LIMIT 5
--bottom 5
SELECT 
 
    team, 
    park, 
     sum(attendance)/games as avg_attendance
FROM homegames
WHERE year='2016' and games>=10
GROUP BY team, park, games
order by avg_attendance 
LIMIT 5

9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

--awardsmanager table 
--managers table 

-- SELECT
--     awardid, 
--     playerid, 
--     lgid,
--     from awardsmanagers
--     WHERE awardid LIKE '%TSN%' and lgid='NL'
--     group by playerid, awardid, lgid
    
   WITH tw as(WITH manager as(SELECT
   playerid,
    awardid,
    
          lgid,
        CASE WHEN lgid='AL' then 1 else 0 
     END AS al_wins,
     CASE WHEN lgid='NL' then 1 else 0
     END AS nl_wins
FROM awardsmanagers
    WHERE awardid LIKE '%TSN%' 
    group by playerid, lgid, awardid) 
    SELECT 
    manager.playerid, 
             
       SUM(manager.al_wins)as alwin, 
    sum(manager.nl_wins)as nlwin
    FROM manager
    WHERE lgid IN ('AL','NL')
    group by manager.playerid
    order by playerid)
    SELECT
    tw.playerid
       FROM tw
       WHERE alwin>0 AND nlwin>0
    
   
    


    

          
 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the playersfirst and last names and the number of home runs they hit in 2016.       

 
 SELECT *
FROM
(
    SELECT
        playerid,
        yearid,
        hr,
        MAX(hr) OVER (PARTITION BY yearid) AS year_best_hr
    FROM batting
)as home_runs
WHERE hr = year_best_hr and yearid between '2000' AND '2016'

with top_hr as
(select *
FROM
(
    SELECT
        b.playerid,
        b.yearid,
        
      p.finalgame::date-p.debut::date AS days_played
 ,      p.debut,
        p.finalgame,
        b.hr,
       SUM(b.hr) OVER (PARTITION BY b.playerid order by yearid) AS year_best_hr
    FROM batting as b
    LEFT JOIN people as p
    on b.playerid=p.playerid
)as home_runs
WHERE hr = year_best_hr and yearid between '2006' AND '2016' 
ORDER BY year_best_hr desc)
SELECT
top_hr.playerid, 
top_hr, yearid,
top_hr.days_played
FROM top_hr
WHERE top_hr.yearid=2016

SELECT 
playerid, 
yearid, 
hr
from batting
where playerid='longoev01'


11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.


SELECT 
t.teamid,
t.w,
t.yearid,
s.salary
from teams as t
LEFT JOIN salaries as s
on t.teamid=s.teamid and t.yearid=s.yearid




