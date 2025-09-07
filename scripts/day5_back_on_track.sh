# scripts/day5_back_on_track.sh
# Sprint Day: 5  | Type: day-specific
# Purpose: One-click: verify env, load CSV -> stage, populate DWH, print counts.

set -euo pipefail

REPO="$HOME/data-analyst-portfolio"
CSV="$REPO/datasets/ecommerce_sales.csv"

cd "$REPO"

# Load .env into this shell
if [[ -f ".env" ]]; then
  while IFS='=' read -r k v; do
    [[ -z "$k" || "$k" =~ ^\s*# ]] && continue
    v="$(echo "${v:-}" | tr -d '\r')"
    [[ -z "$v" ]] && unset "$k" || export "$k"="$v"
  done < .env
fi

: "${PGDATABASE:?PGDATABASE not set in .env}"
: "${PGUSER:?PGUSER not set in .env}"
: "${PGHOST:?PGHOST not set in .env}"

echo "[env] PGDATABASE=$PGDATABASE PGUSER=$PGUSER PGHOST=$PGHOST"
psql -d "$PGDATABASE" -c '\conninfo'

# Venv + deps (optional but helpful)
if [[ -x ".venv/bin/python" ]]; then
  source .venv/bin/activate
  pip show psycopg >/dev/null 2>&1 || pip install -q "psycopg[binary]"
fi

# Sanity on CSV
if [[ ! -f "$CSV" ]]; then
  echo "❌ CSV not found at $CSV"
  exit 1
fi
echo "[file] $(wc -l < "$CSV") lines in $CSV (incl. header)"
head -2 "$CSV" | cat

# Load to staging (TEXT columns, inferred header), replaces table
python scripts/sql/day5_autoload_csv.py \
  --csv "$CSV" \
  --schema stage --table raw_ecommerce --replace

psql -d "$PGDATABASE" -c "SELECT COUNT(*) AS stage_rows FROM stage.raw_ecommerce;"

# Populate DWH
psql -d "$PGDATABASE" -f scripts/sql/day5_populate_dim_fact.sql

# Counts per table
psql -d "$PGDATABASE" -c "
SELECT 'dim_date' tbl, COUNT(*) FROM dwh.dim_date
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dwh.dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dwh.dim_product
UNION ALL SELECT 'fact_sales', COUNT(*) FROM dwh.fact_sales
ORDER BY 1;"
