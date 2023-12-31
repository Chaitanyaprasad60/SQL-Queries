use sqlPractice;
-- So according to pareto principle - 80/20
-- top 20 % products which gives 80% of the sales
-- Our task to find those top 20% of products that give 80% of sales
select so.Product_ID,so.Product_Name,SUM(so.sales) as totalSales from superstore_orders so
group by so.Product_ID
order by totalSales desc limit 200;


select SUM(sales)*0.8 as "80% Sales" from superstore_orders;
-- 1810816

-- So now we will start from highest sales and keep adding until we reach this 80% Sales figure 
-- For this we need a running total

with product_wise_sales as (select so.Product_ID,so.Product_Name,SUM(so.sales) as totalSales from superstore_orders so
group by so.Product_ID),

running_total_table as (
select pws.Product_ID,pws.Product_Name,pws.totalSales,
SUM(pws.totalSales) OVER(order by pws.totalSales desc rows between unbounded preceding and  current row) as running_total_sales from 
product_wise_sales pws) 

select * from running_total_table rtt
where rtt.running_total_sales < (select SUM(sales)*0.8 as "80% Sales" from superstore_orders);

-- 404/1811 
select  (404/1811)*100 as "Products Giving 80% Sales"