/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

--Explore all the countries that the customers come from
SELECT DISTINCT 
	country
FROM gold.dim_customers

--Explore all product categorie(major ones not sub categories)
SELECT DISTINCT 
	category
FROM gold.dim_products

--Explore categories and subcategories 
SELECT DISTINCT 
	category, subcategory
FROM gold.dim_products
ORDER BY category, subcategory

--Explore complete product overview
SELECT DISTINCT 
	category, subcategory, product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name 
