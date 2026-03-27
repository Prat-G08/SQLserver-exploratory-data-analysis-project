/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
SELECT 
	p.category,
	SUM(f.sales_amount) AS sales_per_category
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
)

SELECT 
	category,
	sales_per_category,
	SUM(sales_per_category) OVER() AS total_sales,
	CONCAT(ROUND((sales_per_category * 100.0/SUM(sales_per_category) OVER()), 2), '%') AS percentage
FROM category_sales
