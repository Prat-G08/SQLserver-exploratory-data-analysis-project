/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    3. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
       - Overall profit per product 
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

--1) Base Query: Retrieves core columns from fact_sales and dim_products
WITH base_query AS (
SELECT 
    s.product_key,
    s.sales_amount,
    s.quantity,
    s.price,
    s.customer_key,
    s.order_number,
    s.order_date,
    p.product_name,
    p.category,
    p.cost,
    p.subcategory
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
)

--2) Product Aggregations: Summarizes key metrics at the product level
,aggregated_products AS (
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers,
    MAX(order_date) AS recent_order,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY product_key, product_name, category, subcategory, cost
)

SELECT 
    aggregated_products.*,
    CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END AS product_segment,
    DATEDIFF(month, recent_order, GETDATE()) AS recency,
    CASE WHEN total_orders = 0 THEN 0
	     ELSE total_sales / total_orders
	END AS avg_order_revenue,
    CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_revenue,
    total_sales - (cost * total_quantity) AS lifetime_profit
FROM aggregated_products
