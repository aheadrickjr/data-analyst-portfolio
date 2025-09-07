# scripts/sql/day5_export_artifacts.sh
# Sprint Day: 5 | Type: day-specific
# Purpose: Export summary CSVs for portfolio artifacts.

mkdir -p artifacts/day5

# Sales by country
psql -d "$PGDATABASE" -A -F ',' -P footer=off -c "
SELECT c.country,
       SUM(f.quantity) AS total_qty,
       SUM(f.amount)   AS total_amt
  FROM dwh.fact_sales f
  JOIN dwh.dim_customer c ON c.customer_id_nat = f.customer_id_nat
 GROUP BY c.country
 ORDER BY total_amt DESC NULLS LAST;" \
> artifacts/day5/sales_by_country_summary.csv

# Top 25 products by revenue
psql -d "$PGDATABASE" -A -F ',' -P footer=off -c "
SELECT p.product_id_nat,
       p.product_name,
       SUM(f.quantity) AS total_qty,
       SUM(f.amount)   AS total_amt
  FROM dwh.fact_sales f
  JOIN dwh.dim_product p ON p.product_id_nat = f.product_id_nat
 GROUP BY p.product_id_nat, p.product_name
 ORDER BY total_amt DESC NULLS LAST
 LIMIT 25;" \
> artifacts/day5/top_products_by_revenue.csv
