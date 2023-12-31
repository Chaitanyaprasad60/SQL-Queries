/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.

FINALLY USED - GROUP BY and CTE only. 
*/
use sqlPractice; 
create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

insert into spending values(2,'2019-07-02','desktop',500);
insert into spending values(4,'2019-07-01','desktop',200);

select * from spending;

-- This Query has one problem that is if there are no buyer then it will no show as 0. 
select sub.spend_date,sub.platform as platform,SUM(sub.total) as total,COUNT(distinct sub.user_id) total_users from (
select s.user_id,s.spend_date,s.platform, SUM(amount) as total from spending s
group by user_id,spend_date
having COUNT(distinct platform) = 1 ) sub 
group by sub.spend_date
UNION 
select sub.spend_date,"both" as platform,SUM(sub.total) as total,COUNT(distinct sub.user_id) total_users from (
select s.user_id,s.spend_date, SUM(amount) as total from spending s
group by user_id,spend_date
having COUNT(distinct platform) > 1 ) sub 
group by sub.spend_date
order by spend_date;

select * from spending;

select user_id,spend_date,GROUP_CONCAT(platform) as platform, SUM(amount) as total from spending
group by user_id,spend_date;

with cte as 
(select s.user_id,s.spend_date, SUM(amount) as total,s.platform  from spending s
group by user_id,spend_date
having COUNT(distinct platform) = 1

UNION ALL

select s.user_id,s.spend_date, SUM(amount) as total,"both" as platform from spending s
group by user_id,spend_date
having COUNT(distinct platform) = 2

UNION ALL 

select NULL,s.spend_date, 0 as total,"both" as platform from spending s
)

select COUNT(distinct user_id) as total_users,platform,spend_date,total as total_spent from cte
group by spend_date,platform
order by spend_date;
