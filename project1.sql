create database SQL_project1;

use SQL_project1;

drop table if exists retail_sales_analysis;
create table retail_sales_analysis
(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(15),
quantiy int,
price_per_unit  float,
cogs float,
total_sale float
);

select
count(*)
from retail_sales_analysis;

-- data cleaning 

select * from retail_sales_analysis
where transactions_id is null;

select * from retail_sales_analysis
where sale_date is null;

select * from retail_sales_analysis
where customer_id is null;

select * from retail_sales_analysis
where
transactions_id is null
or
sale_date is null
or 
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- there no nulls in retail_sales_analysis 

-- if there were any nulls we can delete those null buy delete 

delete from retail_sales_analysis
where
transactions_id is null
or
sale_date is null
or 
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;


-- data exploration

select count(*) as gender from retail_sales_analysis;

select count(*) as total_sales from retail_sales_analysis;

-- count of distinct values from category, gender, price_per_unit

select count(distinct category) as distinct_category from retail_sales_analysis;

select count(distinct gender) as distinct_gender from retail_sales_analysis;

select count(distinct price_per_unit) as distinct_price from retail_sales_analysis;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold  4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales_analysis
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold 4 in the month of Nov-2022
select * from retail_sales_analysis
where category = 'Clothing' and
 sale_date  between '2022-11-01' and '2022-11-30'
 and 
quantiy = 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

select category, sum(total_sale) as total_sales,
count(*) as total_count from retail_sales_analysis
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, avg(age) as avg_customers_age from retail_sales_analysis
where category = 'beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales_analysis
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender, category, count(transactions_id) as total_transactions_id
from retail_sales_analysis 
group by category,gender
order by category asc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
 select * from 
 (
 select
 year(sale_date) as yearly_sales,
 month(sale_date) as monthly_sales,
 avg(quantiy) as avg_quantity,
 rank() over(partition by year(sale_date) order by avg(quantiy) desc
 ) as monthly_rank
 from retail_sales_analysis
 group by yearly_sales, monthly_Sales
 ) ranked_sales
 where monthly_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
customer_id,
sum(total_sale) as total_Sales
from retail_sales_analysis
group by customer_id 
order by total_sales
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count(distinct customer_id) as unique_customer
from retail_sales_analysis
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales 
as
(
select * ,
case
when hour(sale_time) < 12 then 'MORNING'
when hour(sale_time) between 12 and 17 then 'AFTERNOON'
else 'EVENING'
end as shift
from retail_sales_analysis
)
select shift,
count(*) as total_count
from hourly_sales
group by shift ;

----------------- END OF PROJECT ---------------------------------------
