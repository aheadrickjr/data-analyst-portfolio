#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/data-analyst-portfolio"

# --- 0) load env + sanity on connection ---
# (if .env not already exported in your shell)
if [ -f .env ]; then
  # shellcheck disable=SC2046
  export $(grep -vE '^\s*#' .env | sed -E 's/\r$//' | xargs -n1)
fi

: "${PGDATABASE:?PGDATABASE not set}"
: "${PGUSER:?PGUSER not set}"
: "${PGHOST:?PGHOST not set}"
: "${PGPORT:?PGPORT not set}"

echo "[env] PGDATABASE=$PGDATABASE PGUSER=$PGUSER PGHOST=$PGHOST PGPORT=$PGPORT"
psql -d "$PGDATABASE" -c '\conninfo'

# --- 1) verify CSV path and show quick peek ---
CSV="/home/arval/data-analyst-portfolio/datasets/ecommerce_sales.csv"
if [ ! -f "$CSV" ]; then
  echo "❌ CSV not found at $CSV"; exit 1
fi
echo "[file] $(wc -l < "$CSV") lines in $CSV (includes header)"
echo "[head]"
head -3 "$CSV" | cat

# --- 2) recreate staging table (text columns + row_id PK) ---
psql -d "$PGDATABASE" <<'SQL'
CREATE SCHEMA IF NOT EXISTS stage;
DROP TABLE IF EXISTS stage.raw_ecommerce;
CREATE TABLE stage.raw_ecommerce(
  row_id       BIGSERIAL PRIMARY KEY,
  invoice_no   TEXT,
  stock_code   TEXT,
  description  TEXT,
  quantity     TEXT,
  invoice_date TEXT,
  unit_price   TEXT,
  customer_id  TEXT,
  country      TEXT
);
SQL

# --- 3) bulk-load via \copy using absolute path ---
psql -d "$PGDATABASE" -c "\copy stage.raw_ecommerce (invoice_no,stock_code,description,quantity,invoice_date,unit_price,customer_id,country) FROM '$CSV' WITH (FORMAT csv, HEADER true, DELIMITER ',')"

# --- 4) verify row count + sample rows ---
psql -d "$PGDATABASE" -c "SELECT COUNT(*) AS stage_count FROM stage.raw_ecommerce;"
psql -d "$PGDATABASE" -c "SELECT * FROM stage.raw_ecommerce LIMIT 5;"
