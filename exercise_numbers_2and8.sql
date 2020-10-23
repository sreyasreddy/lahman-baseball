/* #2. Find the name and height of the shortest player in the database. 
How many games did he play in? What is the name of the team for which he played?*/

SELECT p.playerid, namefirst, namelast, height, g_all,
		(SELECT distinct name
		FROM appearances AS ap JOIN teams AS t
		ON ap.teamid = t.teamid
		WHERE playerid = 'gaedeed01') as team
FROM people AS p
JOIN appearances AS a
ON p.playerid = a.playerid
WHERE height IS NOT NULL
ORDER BY height
LIMIT 1;

SELECT height, namefirst, namelast, g_all, name
FROM people INNER JOIN appearances
USING(playerID)
INNER JOIN teams USING(teamid)
ORDER BY height
LIMIT 1;

/* #8. Using the attendance figures from the homegames table, 
find the teams and parks which had the top 5 average attendance per game in 2016 
(where average attendance is defined as total attendance divided by number of games). 
Only consider parks where there were at least 10 games played. 
Report the park name, team name, and average attendance. 
Repeat for the lowest 5 average attendance.*/

SELECT DISTINCT p.park_name, h.team,
	(h.attendance/h.games) as avg_attendance, t.name		
FROM homegames as h JOIN parks as p ON h.park = p.park
LEFT JOIN teams as t on h.team = t.teamid AND t.yearid = h.year
WHERE year = 2016
AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5;

SELECT DISTINCT p.park_name, h.team,
	(h.attendance/h.games) as avg_attendance, t.name		
FROM homegames as h JOIN parks as p ON h.park = p.park
LEFT JOIN teams as t on h.team = t.teamid AND t.yearid = h.year
WHERE year = 2016
AND games >= 10
ORDER BY avg_attendance
LIMIT 5;

/* #10. Analyze all the colleges in the state of Tennessee.
Which college has had the most success in the major leagues.
Use whatever metric for success you like - number of players,
number of games, salaries, world series wins, etc.*/

--number of players
SELECT schoolname, COUNT(DISTINCT(playerid)) as number_of_players
FROM schools as s INNER JOIN collegeplaying as cp ON s.schoolid = cp.schoolid
WHERE schoolstate = 'TN'
GROUP BY s.schoolid
ORDER BY number_of_players DESC;

--number of games
SELECT schoolname, SUM(g_all) as number_of_games
FROM schools as s INNER JOIN collegeplaying as cp ON s.schoolid = cp.schoolid
INNER JOIN appearances as a ON cp.playerid = a.playerid
WHERE schoolstate = 'TN'
GROUP BY s.schoolid
ORDER BY number_of_games DESC;

--salaries
SELECT schoolname, SUM(salary)::numeric::money as salaries
FROM schools as s INNER JOIN collegeplaying as cp ON s.schoolid = cp.schoolid
INNER JOIN salaries as sa ON cp.playerid = sa.playerid
WHERE schoolstate = 'TN'
GROUP BY s.schoolid
ORDER BY salaries DESC;

--world series wins
SELECT schoolname, COUNT(wswin) as world_series_wins
FROM schools as s INNER JOIN collegeplaying as cp ON s.schoolid = cp.schoolid
INNER JOIN appearances as a ON cp.playerid = a.playerid
INNER JOIN teams as t ON cp.yearid = t.yearid AND a.teamid = t.teamid
WHERE schoolstate = 'TN'
AND wswin = 'Y'
GROUP BY schoolname
ORDER BY world_series_wins DESC;
