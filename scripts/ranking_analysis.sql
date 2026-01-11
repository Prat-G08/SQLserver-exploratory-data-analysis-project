/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--ALL RANKINGS HERE ARE FOR THE TOP VALUES NOT FOR VALUES WHICH HOLD THE SAME RANKING
--THE 'TOP' FUNCTION CAN BE REMOVED TO PROVIDE ALL VALUES WITH A CERTAIN RANKING THAT IS WHY DENSE RANKING HAS BEEN USED
--Finding the top 5 highest revenue generating products 
SELECT TOP 5
	sub.product_name,
	sub.total_revenue,
	sub.rank
FROM(
	SELECT 
		sales.product_key,
		prd.product_name,
		DENSE_RANK() OVER (ORDER BY SUM(sales.sales) DESC) AS rank,
		SUM(sales.sales) AS total_revenue
	FROM gold.fact_sales sales
	LEFT JOIN gold.dim_products prd
		ON prd.product_key = sales.product_key
	GROUP BY sales.product_key, prd.product_name) AS sub
WHERE rank <= 5

--Finding the top 5 worst revenue generating products 
SELECT TOP 5
	sub.product_name,
	sub.total_revenue,
	sub.rank
FROM(
	SELECT 
		sales.product_key,
		prd.product_name,
		DENSE_RANK() OVER (ORDER BY SUM(sales.sales) ASC) AS rank,
		SUM(sales.sales) AS total_revenue
	FROM gold.fact_sales sales
	LEFT JOIN gold.dim_products prd
		ON prd.product_key = sales.product_key
	GROUP BY sales.product_key, prd.product_name) AS sub
WHERE rank <= 5

--Finding the top 10 customers who generated the highest revenue
SELECT TOP 10
	sub.first_name,
	sub.last_name,
	sub.total_revenue,
	rank
FROM(
	SELECT 
		sales.customer_key,
		cst.first_name,
		cst.last_name,
		DENSE_RANK() OVER (ORDER BY SUM(sales.sales) DESC) AS rank,
		SUM(sales.sales) AS total_revenue
	FROM gold.fact_sales sales
	LEFT JOIN gold.dim_customers cst
		ON cst.customer_key = sales.customer_key
	GROUP BY sales.customer_key, cst.first_name, cst.last_name) AS sub
WHERE rank <= 10

--Finding the top 3 customers with the lowest orders placed
SELECT TOP 3
	sub.first_name,
	sub.last_name,
	total_orders,
	sub.rank
FROM(
	SELECT 
		sales.customer_key,
		cst.first_name,
		cst.last_name,
		DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT sales.order_number) ASC) AS rank,
		COUNT(DISTINCT sales.order_number) AS total_orders
	FROM gold.fact_sales sales
	LEFT JOIN gold.dim_customers cst
		ON cst.customer_key = sales.customer_key
	GROUP BY sales.customer_key, cst.first_name, cst.last_name) AS sub
WHERE rank <= 3
