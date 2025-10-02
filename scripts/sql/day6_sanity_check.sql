-- Columns in dim_product
SELECT column_name FROM information_schema.columns
WHERE table_schema='dwh' AND table_name='dim_product' ORDER BY 1;

-- Columns in fact_sales
SELECT column_name FROM information_schema.columns
WHERE table_schema='dwh' AND table_name='fact_sales' ORDER BY 1;

-- Columns in dim_customer and dim_date
SELECT column_name FROM information_schema.columns
WHERE table_schema='dwh' AND table_name='dim_customer' ORDER BY 1;

SELECT column_name FROM information_schema.columns
WHERE table_schema='dwh' AND table_name='dim_date' ORDER BY 1;
