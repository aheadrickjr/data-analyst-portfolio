psql -d "$PGDATABASE" -c "
SELECT COUNT(*) AS total_rows,
       COUNT(*) FILTER (WHERE invoice_date IS NULL OR invoice_date='') AS blank_dates,
       COUNT(*) FILTER (WHERE customer_id IS NULL OR customer_id='')    AS blank_customers,
       COUNT(*) FILTER (WHERE stock_code  IS NULL OR stock_code='')     AS blank_products
FROM stage.raw_ecommerce;"
