-- RECURSIVE CTE Problem 1 - Total year wise sales. 

-- AMAZING LOGIC USED IN THIS PROBLEM 
-- Inner join with dates is also a good logic. 

-- Problem 1 
use sqlPractice; 
/* For each product they want year wise sales. */
create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);


select * from sales;

select DATEDIFF('2019-02-28','2019-01-25');


-- Video Solution approach - He generated all dates inbetween min and maximum dates using recursion and then 
-- inner joined this all dates table with sales table using "BETWEEN" keyword and then grouped them. 
-- He generated a lot of dummy data for this. 
WITH RECURSIVE day_wise_table 
AS (
	
		select min(period_start) as start_date, max(period_end) as end_date from sales -- anchor query. 
        
        UNION ALL 
        
        select DATE_ADD(start_date, INTERVAL 1 DAY) as start_date,end_date from day_wise_table
        where start_date < end_date
)
select s.product_id,YEAR(dwt.start_date) as year,SUM(s.average_daily_sales) as total_sales from sales s
inner join day_wise_table dwt on dwt.start_date BETWEEN s.period_start AND s.period_end
group by YEAR(dwt.start_date),s.product_id;