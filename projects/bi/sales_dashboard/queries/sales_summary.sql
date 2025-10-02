-- queries/sales_summary.sql
SELECT 
    d.date AS order_date,
    c.customer_region,
    p.product_category,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity_sold) AS units_sold
FROM dwh.fact_sales f
JOIN dwh.dim_date d ON f.date_key = d.date_key
JOIN dwh.dim_customer c ON f.customer_key = c.customer_key
JOIN dwh.dim_product p ON f.product_key = p.product_key
GROUP BY d.date, c.customer_region, p.product_category
ORDER BY d.date;
