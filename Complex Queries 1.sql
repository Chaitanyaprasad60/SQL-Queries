-- Question 1 - Create a points with matches played, won and lost. 

use sqlPractice; 


drop table if exists icc_world_cup;
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;


-- My Approach 1

select team as "Team",COUNT(allMatches.team) as "Matches Played",
(select count(icc.Winner) from icc_world_cup icc where icc.Winner = allMatches.team) as "Matches Won",
(COUNT(allMatches.team) - (select count(icc.Winner) from icc_world_cup icc where icc.Winner = allMatches.team)) as "Matches Lost"
 from 
(select icc1.Team_1 as team from icc_world_cup icc1
UNION ALL 
select icc2.Team_2 as team from icc_world_cup icc2) as allMatches
group by allMatches.team;

-- Work by problems - Same query is calculated twice for wins and losts

WITH matchesWon as 
(select count(icc.Winner) from icc_world_cup icc where icc.Winner = allMatches.team) 


select team as "Team",COUNT(allMatches.team) as "Matches Played",
 (select * from matchesWon) as "Matches Won",
 (select * from matchesWon) - COUNT(allMatches.team) as "Matches Lost"
 from 
(select icc1.Team_1 as team from icc_world_cup icc1
UNION ALL 
select icc2.Team_2 as team from icc_world_cup icc2) as allMatches
group by allMatches.team;

-- SOLUTION APPROCH IN LECTURE 

select allMatches.team,COUNT(allMatches.team) as matches_played,SUM(allMatches.win_flag) as matches_won,COUNT(allMatches.team)-SUM(allMatches.win_flag) as "matches_lost"
from (
select Team_1 as team, (Team_1 = Winner) as win_flag
from icc_world_cup
UNION ALL 
select Team_2 as team, case when Team_2=Winner then 1 else 0 end as win_flag
from icc_world_cup) as allMatches
GROUP BY allMatches.team
order by matches_won desc;

-- Approach using JOINS. 

select * from icc_world_cup icc1 
left join 
icc_world_cup icc2 on icc1.Team_2 = icc2.Winner;



