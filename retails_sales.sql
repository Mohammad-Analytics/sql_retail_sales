-- SQL Retail Sales Analysis
CREATE DATABASE portfolio_project;
USE portfolio_project;

-- Create Table
DROP TABLE IF exists retail_sales;
create table retail_sales 
(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT, 
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT, 
cogs FLOAT, 
total_sale FLOAT
);
SELECT * FROM retail_sales
limit 10; 

select count(*) from retail_sales; 

-- Data Cleaning
select * from retail_sales
where transactions_id is null; 

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null
    or total_sale is null; 
        
-- Data Exploration

-- How many sales we have? 
select count(*) as total_sale from retail_sales; 

-- How many unique customers we have? 
select count(distinct customer_id) from retail_sales; 

-- What category product we have? 
select distinct category from retail_sales; 

-- Data Analysis & Business Problem Statements: 

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05.
select * from retail_sales 
where sale_date = '2022-11-05'; 

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022. 

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND
    quantiy >= 4
    and sale_date between '2022-11-01' and '2022-11-30'; 

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

select category, 
sum(total_sale) as net_sale
from retail_sales 
group by category
order by net_sale DESC; 

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as Avg_Age
from retail_sales 
where category = "Beauty"; 

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
 SELECT 
  *
FROM retail_sales
where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,  
    gender, 
    COUNT(transactions_id) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY total_trans Desc;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year. 

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rnk
    FROM (
        SELECT 
            EXTRACT(YEAR FROM sale_date) AS year,
            EXTRACT(MONTH FROM sale_date) AS month,
            AVG(total_sale) AS avg_sale
        FROM retail_sales
        GROUP BY year, month
    ) AS agg
) AS ranked
WHERE rnk = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales. 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5; 

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category. 

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category; 

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17). 

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of Project.  
