psql -d "$PGDATABASE" -c "
WITH c AS (
  SELECT invoice_date FROM stage.raw_ecommerce WHERE invoice_date IS NOT NULL LIMIT 5
)
SELECT * FROM c;
"

psql -d "$PGDATABASE" -c "
SELECT 'dim_date' tbl, COUNT(*) FROM dwh.dim_date
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dwh.dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dwh.dim_product
UNION ALL SELECT 'fact_sales', COUNT(*) FROM dwh.fact_sales
ORDER BY 1;
"
