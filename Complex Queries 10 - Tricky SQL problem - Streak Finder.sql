
-- A person does a task and state is success/fail 
-- Find the steak of succes if from 1-3 if he succedded and on 4- he failed then report 1 - success, 4- fail
-- We need start_date and end_date
use sqlPractice;
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

select t.*,t.state ="success" as stateBin from tasks t;
-- My approach 
-- Without default value its not coming. 

with cte as (
select sub.date_value,sub.state,sub.state != sub.prevState as start, sub.state != sub.nextState as end from (
select t.*,
lag(state,1,"default") over() prevState,
lead(state,1,"default") over() nextState from tasks t) sub)


select t.*,
row_number() over(partition by state) as rn
from tasks t
order by date_value;

-- Now if dates are continuous and if we subtract the rn from date they will all come to starting date

select MIN(sub1.date_value) end_date ,MAX(sub1.date_value) end_date,sub1.state from (
select sub.date_value, sub.state,DATE_ADD(sub.date_value, INTERVAL -sub.rn DAY) group_date from (
select t.*,
row_number() over(partition by state) as rn
from tasks t
order by date_value) sub) sub1 
group by sub1.group_date;



