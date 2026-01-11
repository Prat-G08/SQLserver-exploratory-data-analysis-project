/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To check the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

--Explore all objects in the database
SELECT *
FROM information_schema.tables
ORDER BY table_schema

--Explore all columns in the database(go through each table_name one by one e.g. 'dim_customers')
SELECT *
FROM information_schema.columns
WHERE table_name = 'dim_customers'
