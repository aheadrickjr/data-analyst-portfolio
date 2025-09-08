-- scripts/sql/day6_dashboard_queries.sql
-- Sprint Day: 6 | Type: day-specific
-- Purpose: Queries to drive BI dashboards from DWH star schema.

-- Total revenue by month
SELECT d.year, d.month, SUM(f.amount) AS revenue
FROM dwh.fact_sales f
JOIN dwh.dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- Top 10 customers by spend
SELECT c.customer_id_nat, SUM(f.amount) AS revenue
FROM dwh.fact_sales f
JOIN dwh.dim_customer c ON f.customer_id_nat = c.customer_id_nat
GROUP BY c.customer_id_nat
ORDER BY revenue DESC
LIMIT 10;

-- Sales by product category (if populated, else product_name)
SELECT p.product_name, SUM(f.quantity) AS qty, SUM(f.amount) AS revenue
FROM dwh.fact_sales f
JOIN dwh.dim_product p ON f.product_id_nat = p.product_id_nat
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 15;

-- Revenue by country
SELECT c.country, SUM(f.amount) AS revenue
FROM dwh.fact_sales f
JOIN dwh.dim_customer c ON f.customer_id_nat = c.customer_id_nat
GROUP BY c.country
ORDER BY revenue DESC;

