/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

--Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year's sales

WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS total_sales_amount
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
    order_year,
    product_name,
    total_sales_amount,
    AVG(total_sales_amount) OVER(PARTITION BY product_name) AS total_avg_sales,
    total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) AS diff_in_average,
    CASE 
        WHEN total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) > 0 THEN 'Above average'
        WHEN total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) < 0 THEN 'Below average'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(total_sales_amount) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
    total_sales_amount - LAG(total_sales_amount) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN total_sales_amount - LAG(total_sales_amount) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN total_sales_amount - LAG(total_sales_amount) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
