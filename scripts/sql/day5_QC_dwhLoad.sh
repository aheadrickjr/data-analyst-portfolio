# Did the parser handle both 12/1/2010 and 12/13/2010?
psql -d "$PGDATABASE" -c "
SELECT invoice_date,
       CASE WHEN invoice_date ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}(:\d{2})?$' THEN 'mdy_or_dmy' ELSE 'other' END AS shape
FROM stage.raw_ecommerce
LIMIT 10;"

# Row counts
psql -d "$PGDATABASE" -c "
SELECT 'dim_date' tbl, COUNT(*) FROM dwh.dim_date
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dwh.dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dwh.dim_product
UNION ALL SELECT 'fact_sales', COUNT(*) FROM dwh.fact_sales
ORDER BY 1;"
