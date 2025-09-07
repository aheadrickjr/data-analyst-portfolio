mkdir -p artifacts/day5

# Sales by country
psql -d "$PGDATABASE" -A -F ',' -P footer=off -c \
"SELECT c.country, SUM(f.quantity) qty, SUM(f.amount) amt
   FROM dwh.fact_sales f
   JOIN dwh.dim_customer c ON c.customer_id_nat = f.customer_id_nat
  GROUP BY 1 ORDER BY amt DESC NULLS LAST" > artifacts/day5/sales_by_country_summary.csv

# Top products
psql -d "$PGDATABASE" -A -F ',' -P footer=off -c \
"SELECT p.product_id_nat, p.product_name, SUM(f.quantity) qty, SUM(f.amount) amt
   FROM dwh.fact_sales f
   JOIN dwh.dim_product p ON p.product_id_nat = f.product_id_nat
  GROUP BY 1,2 ORDER BY amt DESC NULLS LAST LIMIT 25" > artifacts/day5/top_products_by_revenue.csv
