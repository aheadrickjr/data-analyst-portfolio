-- scripts/sql/tool_bi_views.sql

-- Make it idempotent: drop then recreate
DROP VIEW IF EXISTS bi.v_sales CASCADE;
DROP VIEW IF EXISTS bi.v_calendar CASCADE;

CREATE SCHEMA IF NOT EXISTS bi;

-- Main Sales View (joins on NAT keys)
CREATE VIEW bi.v_sales AS
SELECT
  dd.date_actual::date                                        AS sale_date,
  COALESCE(NULLIF(dc.state, ''), dc.country)                  AS region,
  dp.category                                                 AS category,
  dp.subcategory                                              AS subcategory,
  dp.brand                                                    AS brand,
  dp.product_name                                             AS product_name,
  f.amount                                                    AS net_amount,
  f.quantity                                                  AS quantity
FROM dwh.fact_sales      AS f
JOIN dwh.dim_date        AS dd  ON dd.date_id         = f.date_id
JOIN dwh.dim_product     AS dp  ON dp.product_id_nat  = f.product_id_nat
JOIN dwh.dim_customer    AS dc  ON dc.customer_id_nat = f.customer_id_nat
;

-- Calendar helper
CREATE VIEW bi.v_calendar AS
SELECT
  dd.date_id,
  dd.date_actual::date AS date,
  dd.year,
  dd.quarter,
  dd.month,
  dd.week        AS week_num,
  dd.day         AS day_of_month
FROM dwh.dim_date AS dd;
