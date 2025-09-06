cat > docs/day_5_customer_analytics.txt <<'LOG'
========================================
DAY 5 SPRINT – Modeling & ETL (Customer Analytics)
========================================

🎯 OBJECTIVE
- Load source CSV into Postgres staging (WSL-first).
- Create a compact star schema: dim_date, dim_customer, dim_product, fact_sales.
- Populate dimensions (Type-1) + fact from staging.
- (Optional) Run a tiny PySpark aggregation for a second artifact.

🧩 PREREQS
- Branch: day5-modeling-etl
- Dataset present: datasets/ecommerce_sales.csv
- .venv active, Postgres client installed
- .env (socket auth): PGUSER=arval, PGDATABASE=postgres  (# PGHOST unset; PGSSLMODE=prefer or commented)

📝 TASKS
1) Create/confirm branch & folders
   - git checkout -b day5-modeling-etl
   - mkdir -p scripts/sql scripts/pyspark artifacts/day5 projects/modeling/customer_analytics

2) Load CSV → staging
   - Script: scripts/sql/day5_autoload_csv.py
   - Usage:
     python scripts/sql/day5_autoload_csv.py --csv datasets/ecommerce_sales.csv --schema stage --table raw_ecommerce
   - Notes: auto-creates stage.raw_ecommerce with TEXT columns based on CSV header.

3) Create star schema DDL
   - File: scripts/sql/day5_create_tables.sql
   - Apply:
     psql -d $PGDATABASE -f scripts/sql/day5_create_tables.sql
   - Tables: dwh.dim_date, dwh.dim_customer, dwh.dim_product, dwh.fact_sales (+ helpful indexes)

4) Populate dims & fact
   - File: scripts/sql/day5_populate_dim_fact.sql
   - Edit the “-- MAP” section to match stage.raw_ecommerce column names
     (tip: \d stage.raw_ecommerce to inspect).
   - Run:
     psql -d $PGDATABASE -f scripts/sql/day5_populate_dim_fact.sql

5) QC checks
   - Row counts:
     psql -d $PGDATABASE -c "SELECT 'dim_date' tbl, COUNT(*) FROM dwh.dim_date
                              UNION ALL SELECT 'dim_customer', COUNT(*) FROM dwh.dim_customer
                              UNION ALL SELECT 'dim_product', COUNT(*) FROM dwh.dim_product
                              UNION ALL SELECT 'fact_sales', COUNT(*) FROM dwh.fact_sales;"
   - Sanity by category:
     psql -d $PGDATABASE -c "SELECT p.category, SUM(fs.quantity) qty, SUM(fs.amount) amt
                              FROM dwh.fact_sales fs JOIN dwh.dim_product p USING (product_id_nat)
                              GROUP BY 1 ORDER BY amt DESC NULLS LAST;"

6) (Optional) PySpark mini-ETL
   - Script: scripts/pyspark/spark_agg_sales.py
   - Run:
     python scripts/pyspark/spark_agg_sales.py --input datasets/ecommerce_sales.csv \
       --output data/processed/day5/sales_by_category
   - Output: Parquet + CSV folder in data/processed/day5/

7) Artifacts & commit
   - Artifacts:
     - Tables: dwh.dim_date, dwh.dim_customer, dwh.dim_product, dwh.fact_sales
     - Files: data/processed/day5/sales_by_category/* (if Spark step)
     - Log: docs/day_5_customer_analytics.txt
   - Commit (example):
     git add scripts/sql/day5_* scripts/pyspark/spark_agg_sales.py docs/day_5_customer_analytics.txt
     git commit -m "feat(day5): staging autoload, star schema DDL, populate, optional Spark agg"
     git push -u origin day5-modeling-etl

💻 COMMANDS / CODE (reference snippets)

# Inspect staging table structure
psql -d $PGDATABASE -c '\d+ stage.raw_ecommerce' 

# Peek a few rows
psql -d $PGDATABASE -c 'SELECT * FROM stage.raw_ecommerce LIMIT 5;'

# Re-run populate after MAP tweaks
psql -d $PGDATABASE -f scripts/sql/day5_populate_dim_fact.sql

# Export a small summary CSV (optional)
psql -d $PGDATABASE -A -F ',' -P footer=off -c \
"SELECT p.category, SUM(fs.quantity) qty, SUM(fs.amount) amt
 FROM dwh.fact_sales fs JOIN dwh.dim_product p USING (product_id_nat)
 GROUP BY 1 ORDER BY amt DESC NULLS LAST" > artifacts/day5/sales_by_category_summary.csv

✅ DONE WHEN
- stage.raw_ecommerce is loaded.
- dim_date/customer/product and fact_sales are populated with sensible counts.
- Category totals query returns non-zero rows.
- (Optional) PySpark outputs exist under data/processed/day5/.

🗒️ NOTES
- If psql complains about sslmode, set PGSSLMODE=prefer or comment it out.
- If the CSV has different headers, update the MAP aliases in day5_populate_dim_fact.sql.
- We keep PGHOST unset to use local Unix socket in WSL.
LOG

