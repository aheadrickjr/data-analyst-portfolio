# See how many rows parsed a date successfully
psql -d "$PGDATABASE" -c "SELECT COUNT(*) AS rows_parsed FROM tmp_norm2 WHERE order_date IS NOT NULL;"

# Counts per table
psql -d "$PGDATABASE" -c "
SELECT 'dim_date' tbl, COUNT(*) FROM dwh.dim_date
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dwh.dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dwh.dim_product
UNION ALL SELECT 'fact_sales', COUNT(*) FROM dwh.fact_sales
ORDER BY 1;"

# A couple of portfolio artifacts
mkdir -p artifacts/day5
psql -d "$PGDATABASE" -A -F ',' -P footer=off -c \
\"SELECT c.country, SUM(f.quantity) qty, SUM(f.amount) amt
   FROM dwh.fact_sales f
   JOIN dwh.dim_customer c ON c.customer_id_nat = f.customer_id_nat
  GROUP BY 1 ORDER BY amt DESC NULLS LAST\" > artifacts/day5/sales_by_country_summary.csv

psql -d "$PGDATABASE" -A -F ',' -P footer=off -c \
\"SELECT p.product_id_nat, p.product_name, SUM(f.quantity) qty, SUM(f.amount) amt
   FROM dwh.fact_sales f
   JOIN dwh.dim_product p ON p.product_id_nat = f.product_id_nat
  GROUP BY 1,2 ORDER BY amt DESC NULLS LAST LIMIT 25\" > artifacts/day5/top_products_by_revenue.csv
