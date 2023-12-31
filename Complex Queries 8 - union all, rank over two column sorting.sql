-- Write a SQL query to find winner of each group 
-- The winner in each group is the one who scores the  maximum points 
-- Total score of each player is the sum of all scores he scored
use sqlPractice;

create table players
(player_id int,
group_id int);

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from players;
select * from matches;

-- My Query 
with allScores as (
select sub.player_id,SUM(sub.score) score from (
select m.first_player as player_id,m.first_score as score from matches m
UNION ALL 
select m.second_player as player_id,m.second_score as score from matches m
) sub 
group by sub.player_id)

select  v.group_id,v.player_id from (
select p.*,row_number() over(partition by p.group_id order by score desc) rn from players p
inner join allScores a on a.player_id = p.player_id) v
where rn = 1;

-- Query in lecture
with allScores as (
select sub.player_id,SUM(sub.score) score from (
select m.first_player as player_id,m.first_score as score from matches m
UNION ALL 
select m.second_player as player_id,m.second_score as score from matches m
) sub 
group by sub.player_id)

select  v.group_id,v.player_id from (
select p.*,rank() over(partition by p.group_id order by score desc,player_id asc) rn from players p
inner join allScores a on a.player_id = p.player_id) v
where rn = 1;