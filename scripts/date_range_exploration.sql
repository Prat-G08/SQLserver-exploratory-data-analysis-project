/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the boundaries of important data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

--Finding the date for the first and last order 
SELECT DISTINCT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date
FROM gold.fact_sales

--How many years of sales are available 
SELECT DISTINCT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS years_of_sales 
FROM gold.fact_sales
 
--Finding the youngest and oldest customer 
SELECT DISTINCT
	MAX(birthdate) AS youngest_birthdate,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age,
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age
FROM gold.dim_customers
