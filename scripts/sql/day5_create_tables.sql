-- scripts/sql/day5_create_tables.sql
-- Sprint Day: 5 | Type: day-specific
-- Purpose: Create DWH star tables (idempotent).

CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_date (
  date_id     INTEGER PRIMARY KEY,
  date_actual DATE NOT NULL,
  year        INTEGER,
  quarter     INTEGER,
  month       INTEGER,
  day         INTEGER,
  week        INTEGER
);

CREATE TABLE IF NOT EXISTS dwh.dim_customer (
  customer_id_nat TEXT PRIMARY KEY,
  customer_name   TEXT,
  email           TEXT,
  city            TEXT,
  state           TEXT,
  country         TEXT,
  segment         TEXT
);

CREATE TABLE IF NOT EXISTS dwh.dim_product (
  product_id_nat TEXT PRIMARY KEY,
  product_name   TEXT,
  category       TEXT,
  subcategory    TEXT,
  brand          TEXT
);

CREATE TABLE IF NOT EXISTS dwh.fact_sales (
  order_id_nat     TEXT,
  date_id          INTEGER REFERENCES dwh.dim_date(date_id),
  customer_id_nat  TEXT REFERENCES dwh.dim_customer(customer_id_nat),
  product_id_nat   TEXT REFERENCES dwh.dim_product(product_id_nat),
  quantity         NUMERIC,
  amount           NUMERIC
);
