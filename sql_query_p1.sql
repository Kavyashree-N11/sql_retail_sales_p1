-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create Table
CREATE TABLE retail_sales 
            (
               transaction_id INT PRIMARY KEY,
               sale_date DATE,
               sale_time TIME,
               customer_id INT,
               gender VARCHAR(15),
               age INT, 
               category VARCHAR(15), 
               quantity INT,
               price_per_unit FLOAT,
               cogs FLOAT,
               total_sale FLOAT
			   );
SELECT * FROM retail_sales
LIMIT 10

SELECT 
    COUNT(*)
FROM retail_sales

SELECT * FROM retail_sales
WHERE 
      transaction_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
      gender IS NULL 
	  OR
      category IS NULL
	  OR
      quantity IS NULL
	  OR
      cogs IS NULL
	  OR
      total_sale IS NULL;

--Data Exploration

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Data Analysis and Business Key Problems and Answers

Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

Q2. Write a SQL query to retrieve all transactions where the category is 
clothing and the quantity sold is the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing' 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND 
	quantity >= 4 

Q3. Write a SQL query to calculate the total sales (total_sale) for each 
category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

Q4. Write a sql query to find the average age of customers who purchased items 
from the 'beauty' category.

SELECT 
    Round(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

Q5. Write a SQL query to find all transactions where the total_sale 
is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale >1000

Q6. Write a SQL query to find the total number of tansactions(transaction_id)
made by each gender in each category.

SELECT 
      category, 
	  gender, 
	  Count(*) as total_trans
FROM retail_sales
GROUP BY
      category, 
	  gender
ORDER BY 1

Q7. Write a Sql query to calculate the average sale for each month. 
Find out best selling month in each year.

SELECT 
      year, 
	  month, 
	  avg_sale
FROM(
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(month FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(tOtal_sale) DESC) as rank 
FROM retail_sales
group by 1, 2
ORDER BY 1, 3 DESC
) as t1
WHERE rank  = 1

Q8. Write a SQL query to find the top 5 customers based on the highest 
total sales.

Select 
    customer_id, 
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

Q9. Write a sql query to find the number of unique customers who purchased
items from each category.

SELECT 
    category, 
	COUNT(DISTINCT customer_id) cnt_unique_cs
FROM retail_sales
group by category

Q10. Write a sql query to create each shift and number of orders 
(Example Morning <=12, Afternoon Between 12 and 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *, 
    CASE 
       WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
       WHEN EXTRACT(HOUR FROM sale_time) Between 12 AND 17 THEN 'Afternoon' 
       ELSE 'Evening'
   END AS shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
