
-- Question 7 - Analysing Data to find Percent Cancelled rides. 
use sqlPractice;

Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');



select * from Trips;
select * from Users;

with cte as (
select t.request_at,t.status,COUNT(t.status) over(partition by t.request_at) as trip_count from Trips t
inner join Users c on t.client_id = c.users_id and c.banned = "No"
inner join Users d on t.driver_id = d.users_id and d.banned = "No")

select (select SUM(c.trip_count) from cte c where c.status != "completed")/(select SUM(c.trip_count) from cte c)*100 as "Cancellation rate";

select t.id,t.client_id,t.driver_id,t.request_at,t.status from Trips t
inner join Users c on t.client_id = c.users_id and c.banned = "No"
inner join Users d on t.driver_id = d.users_id and d.banned = "No";

with cte as (
select t.request_at,(case when t.status != "completed" then 0 else 1 end) as status,
COUNT(*) over(partition by request_at) as total_rides from Trips t
inner join Users c on t.client_id = c.users_id and c.banned = "No"
inner join Users d on t.driver_id = d.users_id and d.banned = "No"
where t.request_at < "2013-10-03" &&  t.request_at > "2013-10-01")

select c.request_at,SUM(status)/c.total_rides*100 as "Cancelletion Rate"
from cte c
group by c.request_at;



select t.request_at,t.status = "completed"  status from Trips t
inner join Users c on t.client_id = c.users_id and c.banned = "No"
inner join Users d on t.driver_id = d.users_id and d.banned = "No";

select t.request_at  Day,ROUND(SUM(t.status != "completed")/COUNT(t.request_at),2) status from Trips t
inner join Users c on t.client_id = c.users_id and c.banned = "No"
inner join Users d on t.driver_id = d.users_id and d.banned = "No"
group by t.request_at;
