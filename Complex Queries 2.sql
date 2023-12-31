use sqlPractice;

drop table if exists customer_orders;
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-02-01' as date),2000),(5,400,cast('2022-02-01' as date),2200),(6,500,cast('2022-02-01' as date),2700)
,(7,100,cast('2022-03-01' as date),3000),(8,400,cast('2022-03-01' as date),1000),(9,600,cast('2022-03-01' as date),3000);


-- Added more customer for load testing. 
select * from customer_orders;

-- Find New Cusromers and repeat customer. 

-- My Approach 
select DISTINCT monthname(s.order_date) as month,
(select COUNT(s2.customer_id) from customer_orders s2 where MONTH(s2.order_date) = MONTH(s.order_date) and s2.customer_id NOT IN 
(select s1.customer_id from customer_orders s1 where MONTH(s1.order_date) < MONTH(s2.order_date))
) as new_customers
from customer_orders s;

-- Instead of this if we can have the first date of each customer then we can know if he is new or not

with cte as (
select co.customer_id, min(co.order_date) as firstOrder from
customer_orders co
group by co.customer_id) 

select monthname(ss.order_date) as month, SUM(ss.newOrder) as new_orders, SUM(ss.repeatOrder) as repeat_orders  from (
select (c.firstOrder = co.order_date) as newOrder,(c.firstOrder != co.order_date) as repeatOrder,co.order_date
from customer_orders co
left join cte c on c.customer_id = co.customer_id) ss
group by ss.order_date;