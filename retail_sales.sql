--SQL Retail Sales Analysis -P1

--Create table
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
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
LIMIT 10;

SELECT COUNT(*) FROM retail_sales ;

--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

v
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL;

--Data Cleaning

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL;

--Data Exploration

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

--How many UNIQUE/DISTINCT customers we have?
SELECT COUNT(DISTINCT(customer_id)) as total_customer FROM retail_sales;

--What many distinct categories
SELECT DISTINCT(category) from retail_sales;


--Data Analysis and Key Business Problems  
--Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is >= 4 in the month of Nov 2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity>= 4
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11';

--Q3 Write an SQL query to calculate the total sales (total_sale) for each category
SELECT SUM(total_sale) as total_sale,
COUNT(*) as total_orders,
category 
FROM retail_sales
GROUP BY(category);

--Q4 Write an SQL query to find the avg age of the customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2 ) as avg_age
FROM retail_sales
GROUP BY (category)
HAVING category='Beauty';

SELECT ROUND(AVG(age),2 ) as avg_age
FROM retail_sales
WHERE category='Beauty';

--Q5 Write an SQL query to find all txn where the total_sale is >1000
SELECT * FROM retail_sales
WHERE total_sale>1000;

--Q6 Write an SQL query to find the total number of transactions(transaction_id) made by each gender in each category
SELECT COUNT(transactions_id) as txns,gender,category
FROM retail_sales
GROUP BY (gender,category)
ORDER BY 3;

--Q7 Write an SQL query to calculate the average sale for each month. Find out th best selling month in each year
SELECT year, month, monthly_sales FROM
(SELECT
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
(AVG(total_sale)) as monthly_sales,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY (1,2)) as t1
WHERE rank = 1;
--ORDER BY 1,3 DESC;

--Q8 Write an SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,SUM(total_sale) as tot
FROM retail_sales
GROUP BY 1
ORDER BY tot DESC
LIMIT 5;

--Q9 Write an SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT(customer_id)) FROM retail_sales
GROUP BY category

--Q10 Write an SQL query to create each shift and number of orders(Eg Morning <=12, Afternoon (Between 12 and 17) and Evening>17)
SELECT COUNT(quantity),
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
GROUP BY shift;

--or
WITH hourly_sale
AS
(SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;


--EOP--
