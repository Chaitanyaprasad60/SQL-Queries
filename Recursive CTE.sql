-- RECURSION IN SQL. 
-- Here RECURSIVE MUST BE ADDED IF THE CTE IS REFERING TO ITSELF. in MYSQL. 
-- MYSQL Documentation - https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive


WITH RECURSIVE cte_numbers 
AS (
	
		select 1 as num -- anchor query 
        
        UNION ALL 
        
        select num+1  -- recursive query 
        from cte_numbers
        where num < 6 -- Filter to stop recursion. 
)
select num 
from cte_numbers; 





