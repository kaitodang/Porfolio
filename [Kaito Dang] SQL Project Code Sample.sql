-- BASIS SQL

-- Select the earliest and lastest date

/* 
select min(occurred_at) earlies_day,
    max(occurred_at) lastest_day
from orders 
*/

-- Find all the Company whose names starts with an single vowels

/* 
select * 
from accounts
where name like 'a%'
    or name like 'e%'
    or name like 'i%'
    or name like 'o%'
    or name like 'u%' 
*/

-- The number of distinct date in the orders table

/* 
select count(distinct DATEFROMPARTS(year(occurred_at), MONTH(occurred_at),day(occurred_at))) as new_date
from orders
order by DATEFROMPARTS(year(occurred_at), MONTH(occurred_at),day(occurred_at)) desc 
*/

-- Select distinct date in the orders table

/* 
select distinct DATEFROMPARTS(year(occurred_at), MONTH(occurred_at),day(occurred_at)) as new_date
from orders
order by DATEFROMPARTS(year(occurred_at), MONTH(occurred_at),day(occurred_at)) desc 
*/

-- The number of distinct year in orders table

/* 
select distinct year(occurred_at)
from orders
order by year(occurred_at) asc 
*/

-- JOIN & AGGREGATIONS

-- Count the number of account each sale_rep

/* 
select s.name Name, 
    count(*) Count_account
from sales_reps s 
join accounts a
on s.id = a.sales_rep_id
group by s.name
order by count(*) 
*/

-- Count the number of sales_rep each region

/* 
select r.name,
    count(*) count_sales
from region r
join sales_reps s 
on r.id = s.region_id
group by r.name
order by r.name 
*/

-- Looking for the sum of quantity and usd each sales for each accounts
/* 
select s.name sales_name,
    a.name,  
    sum(o.total) total,
    sum(o.total_amt_usd) total_amt_usd
from orders o 
join accounts  a 
on o.account_id = a.id 
join sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, a.name
order by s.name 
*/

-- SUBQUERIES & TEMPORARY TABLES

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

/* 
with t1 as (
    select r.name region, 
        s.name sales, 
        sum(o.total_amt_usd) total_amt_usd
    from orders o 
    join accounts a 
    on o.account_id = a.id
    join sales_reps s 
    on a.sales_rep_id = s.id
    join region r 
    on r.id = s.region_id
    group by r.name, s.name
),
t2 as (
    select region, 
        max(total_amt_usd) max_total_amt_usd
    from t1
    group by region) 
select t1.sales, t2.region, round(t2.max_total_amt_usd,0) max_total_amt_usd
from t2
join t1
on t1.region = t2.region and t1.total_amt_usd = t2.max_total_amt_usd
order by t2.max_total_amt_usd desc 
*/

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

/* 
select r.name, 
    count(*) total_orders
from orders o 
    join accounts a 
    on o.account_id = a.id
    join sales_reps s 
    on a.sales_rep_id = s.id
    join region r 
    on r.id = s.region_id
    group by r.name
    having sum(o.total_amt_usd) =(
        select max(total_amt_usd)
        from (
            select r.name region,  
                sum(o.total_amt_usd) total_amt_usd
            from orders o 
            join accounts a 
            on o.account_id = a.id
            join sales_reps s 
            on a.sales_rep_id = s.id
            join region r 
            on r.id = s.region_id
            group by r.name
            ) t1
            ) 
*/

-- Create a view of 100 accounts having the highest total and highest total_amt_usd
/* 
create view [top_100_accounts] as
select top 100  a.name, 
    sum(o.total) sum_total, 
    sum(o.total_amt_usd) sum_total_amt_usd
from accounts a 
join orders o 
on a.id = o.account_id
group by a.name
order by sum(o.total) desc 
*/
/* 
select * 
from top_100_accounts
*/

