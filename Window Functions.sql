
-- WINDOW FUNCTION - RANK, OVER, PARTITION, ROWS BETWEEN BY ETC.. 
use sqlPractice;

drop table if exists employees ;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255),
    employee_department VARCHAR(50),
    employee_salary DECIMAL(10, 2)
);

-- Insert data
INSERT INTO employees (employee_id, employee_name, employee_department, employee_salary)
VALUES
    (1, 'John Doe', 'HR', 50000.00),
    (2, 'Jane Smith', 'Tech', 60000.00),
    (3, 'Bob Johnson', 'Management', 75000.00),
    (4, 'Alice Brown', 'Staff', 45000.00),
    -- Add 16 more rows as needed
    (5, 'Charlie Davis', 'HR', 50000.00),
    (6, 'Eva Rodriguez', 'Tech', 62000.00),
    (7, 'David Lee', 'Management', 78000.00),
    (8, 'Sophie Turner', 'Staff', 47000.00),
    -- Add 12 more rows as needed
    (9, 'Michael White', 'HR', 51000.00),
    (10, 'Olivia Taylor', 'Tech', 65000.00),
    (11, 'Richard Johnson', 'Management', 78000.00),
    (12, 'Grace Miller', 'Staff', 49000.00),
    -- Add 8 more rows as needed
    (13, 'Samuel Brown', 'HR', 48000.00),
    (14, 'Emily Harris', 'Tech', 58000.00),
    (15, 'Daniel Wilson', 'Management', 70000.00),
    (16, 'Lily Jones', 'Staff', 46000.00),
    -- Add 4 more rows as needed
    (17, 'Matthew Davis', 'HR', 53000.00),
    (18, 'Ava Martinez', 'Tech', 68000.00),
    (19, 'Joseph Robinson', 'Management', 77000.00),
    (20, 'Emma Garcia', 'Staff', 46000.00);
    
    
-- If you have to find the maximum salary and then row contaiing that salary
select max(employee_salary) as maximum_salary from employees e;
select * from employees where employee_salary = (select max(employee_salary) as maximum_salary from employees e);

-- FIND maximum salary department wise we can use group by 
select employee_department,max(employee_salary) as maximum_salary
from employees
group by employee_department;

-- Now if you want to display maximum salary as a extra column with all employee details 
-- HERE over() has created a window and as we have not mentioned any coun inside over() it create 1 window for all of these 20 records. 
-- Here MAX is now acting as a WINDOW function and not a aggregate function die to over()

select e.* ,
MAX(e.employee_salary) over() as max_salary
from employees e;

-- NOW I want to extract maximum salary of each department as the extra columns then 
-- Here a window is created for each department and then the MAX() is applied only for that window. 
select e.* ,
MAX(e.employee_salary) over(partition by e.employee_department) as max_salary
from employees e;

-- SOME SPECIAL WINDOW FUNCTIONS - row_numer(), rank(), lead, lag, 
-- row_number() 
-- Here a row number is assigned to all the rows considering all 20 records as a window. 
select e.* ,
row_number()  over() as max_salary
from employees e;

-- here  each employee department is assigned a row_number() seperately
select e.* ,
row_number()  over(partition by e.employee_department) as max_salary
from employees e;

-- Fetch 1st two employees who joined the company assuming employee id is assigned first come first serve
select * from (
select e.* ,
row_number()  over(partition by e.employee_department order by e.employee_id) as rn
from employees e) sub 
where sub.rn < 3;

-- FETCH top 3 employees of each department
-- rank() and row_number() are almost similar except row_number assigns unique values to all rows in its window 
-- but rank gives same rank for same values in a window and skips next value eg: 1 2 2 4
-- dense rank is same as rank but it doesn;t skip values. 
select e.* ,
rank()  over(partition by e.employee_department order by e.employee_salary desc ) as rnk,
dense_rank()  over(partition by e.employee_department order by e.employee_salary desc ) as dnk
from employees e;


select * from (
select e.* ,
rank()  over(partition by e.employee_department order by e.employee_salary desc ) as rnk
from employees e) sub 
where sub.rnk <= 3;


-- lag and lead 
-- In a given window lag will provide a column that has the previous row's value. 
-- Extra arguments - lag(column, number of records to skip, default value)
select e.* ,
lag(e.employee_salary,2,0)  over(partition by e.employee_department order by e.employee_salary desc ) as lagSalary,
lead(e.employee_salary,1,0)  over(partition by e.employee_department order by e.employee_salary desc ) as leadSalary
from employees e;




-- ROWS Between 
select * from employees;
-- Now Imagine  you want a running salary total for each row. You can consider the window as all rows before this row. 

select e.employee_id,e.employee_name,e.employee_salary,
SUM(e.employee_salary) OVER(order by employee_id rows between unbounded preceding and 0 preceding) as running_total_salary
from employees e;

-- HERE "rows between" helps us define a window 
-- unbounded preceding, unbounded following, current row
-- You can also mention 0,1,2.. preceding meaning the window size is just that
-- Use "And" to merge two or more windows. 

-- SOME other window function are ntile, nth value, 1st value, last value. 





