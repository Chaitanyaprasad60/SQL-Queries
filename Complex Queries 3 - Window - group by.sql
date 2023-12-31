use sqlPractice;

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR'),
('C','Bangalore','B2@gmail.com',3,'MONITOR'),('C','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

-- My approach 
select e.name, COUNT(*) as total_vists, 
(select e1.floor from entries e1 where e1.name = e.name group by e1.floor order by count(e1.floor) desc limit 1 ) as most_visited_floor
,GROUP_CONCAT(DISTINCT e.resources) as resources
from entries e
group by e.name;



-- Using window function 

with most_visited_floor as (
select sub.name,sub.floor as most_visited from (
select name,floor,
rank() over(partition by name order by count(1) desc) as rn from entries 
group by name,floor) as sub
where sub.rn = 1
)
select e.name, COUNT(*) as total_vists,mvf.most_visited,
GROUP_CONCAT(DISTINCT e.resources) as resources
from entries e
left join most_visited_floor mvf on mvf.name = e.name
group by e.name;





