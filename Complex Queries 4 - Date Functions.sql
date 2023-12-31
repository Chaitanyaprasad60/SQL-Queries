use sqlPracice; 

-- Write a query to provide the date for nth occurance of sunday in future from given date 
-- If today is saturday 2022-01-01 then 1st Sunday is 2022-01-02, 2nd Sunday is 2022-01-09 .. 
-- datepart

set @today_date = '2023-11-05'; -- saturday 
set @n = 3;
-- 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday.

select ((6-WEEKDAY(@today_date)) + (@n-1)*7) INTO @days_left;
select DATE_ADD(@today_date, INTERVAL @days_left DAY) as "nth Occurance";

select NOW();