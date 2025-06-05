-- Portfolio Project
-- Datasets sources: 
-- https://github.com/najirh/Retail-Sales-Analysis-SQL-Project--P1/blob/main/SQL%20-%20Retail%20Sales%20Analysis_utf%20.csv

-- Create database by using the command 'CREATE DATABASE sql_project_p1' where the name is 'sql_project_p1'

CREATE DATABASE sql_project_p1;

-- To check on databases available
SHOW DATABASES;
-- Import data into the database

-- Insert table 'retailsales' by either right clicking on the table and then select 'Table Data Import Wizard', then browse the data you need to import and finish the process.

SELECT * 
FROM retailsales;

-- Alternatively
-- Create table by using command
DROP TABLE IF EXISTS retalsales;
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
            sale_date	DATE,
            sale_time TIME,
            customer_id	INT,
            gender	VARCHAR(15),
            age INT,
            category VARCHAR(15),
            quantity INT,
            price_per_unit FLOAT,
            cogs FLOAT,
            total_sale FLOAT
          );  
-- Then import your data by right clicking on table and selecting 'Table Data Import Wizard' and finishing the process.

SELECT * 
FROM retail_sales;

-- Data Cleaning: To confirm if we have imported all the rows

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(*) FROM retailsales;

-- To check if there are any empty columns,
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    customer_id IS NULL
    OR  
    gender IS NULL
    OR 
    age IS NULL
    OR 
    category IS NULL
    OR 
    quantity IS NULL
    OR 
    price_per_unit IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
    -- Data Exploration

-- Number of sales made
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- To identify unique categories
SELECT DISTINCT category AS total_customers
FROM retail_sales;

-- Data Analysis and Key Business Problems and Answer
 -- Q.1 Write a SQL to retrieve all columns for sale made on '2022-11-05'
 SELECT *
 FROM retail_sales
 WHERE sale_date = '2022-11-05';

 -- Q.2 Write a SQL query to retriev all transactions where the category is  'clothing' and the quanity is more than 2 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing'
AND 
quantity > 2
AND sale_date >= '2022-11-01' AND sale_date < '2022-12-01';

-- Q.3  Total sales (total_sales) for each category
SELECT 
	category, 
    SUM(total_sale) AS NET_SALE,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 The avarege age of customers who purchased items from the 'Beauty' category, rounded to 2 decimal places.
SELECT ROUND(AVG(age), 2) AS Avarage_age
FROM retail_sales
WHERE category = 'Beauty'
ORDER BY AVG(age);

-- Q. 5 All transactions where total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale >1000;

-- Q.6 Total number of transactions (transaction_id) made by each gender on each category
SELECT 
	category, 
	gender, 
	COUNT(*) AS total_trans
FROM retail_sales
	GROUP BY category, gender
ORDER BY category;


-- Q.7 Average sales for each month and the best selling month each year
SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month, 
    ROUND(AVG(total_sale), 2) AS avg_sale,
    RANK() OVER(PARTITION BY year(sale_date)
    ORDER BY AVG(total_sale) DESC) AS rank_in_year
FROM retail_sales
GROUP BY year, month;

-- To filter the best selling months each year, I will need to need to create a subquery or CTE to include the where clause
SELECT * FROM
	(SELECT 
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month, 
		ROUND(AVG(total_sale), 2) AS avg_sale,
		RANK() OVER(PARTITION BY year(sale_date)
		ORDER BY AVG(total_sale) DESC) AS rank_in_year
	FROM retail_sales
	GROUP BY year, month) AS t1
WHERE rank_in_year = 1;

-- Q.8 Top 5 customers based on the highest total_sale
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 NUmber of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS count_of_unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Create shifts and number of order such as morning <12, afternoon between 12 and 17 and evening > 17
SELECT *
FROM retail_sales;

WITH CTE
AS
(
SELECT *,
	CASE 
    WHEN sale_time < '12:00:00' THEN 'Morning'
    WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
ELSE 'Evening'  
    END AS Shift
FROM retail_sales)
SELECT  
	shift,
	COUNT(transactions_id) AS total_orders
FROM CTE
GROUP BY shift;

-- End of project
