-- scripts/sql/day5_populate_dim_fact.sql
-- Sprint Day: 5 | Type: day-specific
-- Purpose: Populate dwh dims & fact from stage.raw_ecommerce with
--          (1) MM/DD vs DD/MM disambiguation and
--          (2) duplicate-safe upserts via DISTINCT ON.

BEGIN;

-- Rebuild session-scoped normalized view
DROP VIEW IF EXISTS tmp_norm2;

CREATE TEMP VIEW tmp_norm2 AS
WITH src AS (
  SELECT
    NULLIF(invoice_no,   '')              AS order_id_nat,
    NULLIF(invoice_date, '')              AS invoice_ts_raw,
    NULLIF(customer_id,  '')              AS customer_id_nat,
    NULLIF(stock_code,   '')              AS product_id_nat,
    NULLIF(description,  '')              AS product_name,
    NULLIF(country,      '')              AS country,
    NULLIF(quantity,     '')::numeric     AS quantity,
    NULLIF(unit_price,   '')::numeric     AS unit_price,
    NULL::text AS segment, NULL::text AS category,
    NULL::text AS subcategory, NULL::text AS brand
  FROM stage.raw_ecommerce
),
parts AS (
  SELECT
    s.*,
    split_part(s.invoice_ts_raw, ' ', 1)                                AS dpart,
    NULLIF(split_part(split_part(s.invoice_ts_raw,' ',1), '/', 1), '')  AS n1_txt,
    NULLIF(split_part(split_part(s.invoice_ts_raw,' ',1), '/', 2), '')  AS n2_txt
  FROM src s
),
norm AS (
  SELECT
    order_id_nat,
    /* Disambiguate dd/mm vs mm/dd by inspecting the first two numbers.
       - If n1>12 => dd/mm
       - Else if n2>12 => mm/dd
       - Else default mm/dd (common in this dataset)
       Support HH:MI[:SS]; ignore ISO fallback if unmatched. */
    COALESCE(
      CASE
        WHEN invoice_ts_raw ~ '^\s*\d{1,2}/\d{1,2}/\d{4}\s+\d{1,2}:\d{2}:\d{2}\s*$' THEN
          CASE
            WHEN n1_txt ~ '^\d+$' AND n2_txt ~ '^\d+$' AND n1_txt::int > 12
              THEN to_timestamp(invoice_ts_raw, 'DD/MM/YYYY HH24:MI:SS')
            WHEN n1_txt ~ '^\d+$' AND n2_txt ~ '^\d+$' AND n2_txt::int > 12
              THEN to_timestamp(invoice_ts_raw, 'MM/DD/YYYY HH24:MI:SS')
            ELSE to_timestamp(invoice_ts_raw, 'MM/DD/YYYY HH24:MI:SS')
          END
        WHEN invoice_ts_raw ~ '^\s*\d{1,2}/\d{1,2}/\d{4}\s+\d{1,2}:\d{2}\s*$' THEN
          CASE
            WHEN n1_txt ~ '^\d+$' AND n2_txt ~ '^\d+$' AND n1_txt::int > 12
              THEN to_timestamp(invoice_ts_raw, 'DD/MM/YYYY HH24:MI')
            WHEN n1_txt ~ '^\d+$' AND n2_txt ~ '^\d+$' AND n2_txt::int > 12
              THEN to_timestamp(invoice_ts_raw, 'MM/DD/YYYY HH24:MI')
            ELSE to_timestamp(invoice_ts_raw, 'MM/DD/YYYY HH24:MI')
          END
        ELSE NULL
      END,
      -- ISO-ish fallbacks
      to_timestamp(invoice_ts_raw, 'YYYY-MM-DD HH24:MI:SS'),
      to_timestamp(invoice_ts_raw, 'YYYY-MM-DD HH24:MI'),
      to_timestamp(invoice_ts_raw, 'YYYY-MM-DD"T"HH24:MI:SS')
    )                                          AS order_ts,
    customer_id_nat,
    product_id_nat,
    product_name,
    country, segment, category, subcategory, brand,
    quantity,
    (quantity * unit_price)                    AS amount
  FROM parts
)
SELECT
  order_id_nat,
  (order_ts)::date                             AS order_date,
  COALESCE(customer_id_nat, 'UNKNOWN')         AS customer_id_nat,
  COALESCE(product_id_nat,  'UNKNOWN')         AS product_id_nat,
  product_name,
  country, segment, category, subcategory, brand,
  quantity, amount
FROM norm;

-- Seed UNKNOWNs so FKs have a target
INSERT INTO dwh.dim_customer (customer_id_nat, country, segment)
VALUES ('UNKNOWN', NULL, NULL)
ON CONFLICT (customer_id_nat) DO NOTHING;

INSERT INTO dwh.dim_product (product_id_nat, product_name, category, subcategory, brand)
VALUES ('UNKNOWN', NULL, NULL, NULL, NULL)
ON CONFLICT (product_id_nat) DO NOTHING;

-- ========= dim_date =========
INSERT INTO dwh.dim_date (date_id, date_actual, year, quarter, month, day, week)
SELECT DISTINCT
  (EXTRACT(YEAR FROM order_date)::int * 10000
   + EXTRACT(MONTH FROM order_date)::int * 100
   + EXTRACT(DAY FROM order_date)::int)        AS date_id,
  order_date                                   AS date_actual,
  EXTRACT(YEAR FROM order_date)::int           AS year,
  EXTRACT(QUARTER FROM order_date)::int        AS quarter,
  EXTRACT(MONTH FROM order_date)::int          AS month,
  EXTRACT(DAY FROM order_date)::int            AS day,
  EXTRACT(WEEK FROM order_date)::int           AS week
FROM tmp_norm2
WHERE order_date IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

-- ========= dim_customer (duplicate-safe) =========
INSERT INTO dwh.dim_customer (customer_id_nat, customer_name, email, city, state, country, segment)
SELECT DISTINCT ON (customer_id_nat)
  customer_id_nat, NULL, NULL, NULL, NULL, country, segment
FROM tmp_norm2
WHERE customer_id_nat IS NOT NULL
ORDER BY customer_id_nat
ON CONFLICT (customer_id_nat) DO UPDATE
SET country = EXCLUDED.country,
    segment = EXCLUDED.segment;

-- ========= dim_product (duplicate-safe) =========
INSERT INTO dwh.dim_product (product_id_nat, product_name, category, subcategory, brand)
SELECT DISTINCT ON (product_id_nat)
  product_id_nat, product_name, category, subcategory, brand
FROM tmp_norm2
WHERE product_id_nat IS NOT NULL
ORDER BY product_id_nat
ON CONFLICT (product_id_nat) DO UPDATE
SET product_name = EXCLUDED.product_name,
    category     = EXCLUDED.category,
    subcategory  = EXCLUDED.subcategory,
    brand        = EXCLUDED.brand;

-- ========= fact_sales =========
INSERT INTO dwh.fact_sales
  (order_id_nat, date_id, customer_id_nat, product_id_nat, quantity, amount)
SELECT
  order_id_nat,
  (EXTRACT(YEAR FROM order_date)::int * 10000
   + EXTRACT(MONTH FROM order_date)::int * 100
   + EXTRACT(DAY FROM order_date)::int)        AS date_id,
  customer_id_nat,
  product_id_nat,
  quantity,
  amount
FROM tmp_norm2
WHERE order_date IS NOT NULL;

COMMIT;
