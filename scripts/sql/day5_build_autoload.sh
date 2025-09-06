mkdir -p scripts/sql
cat > scripts/sql/day5_autoload_csv.py <<'PY'
# -*- coding: utf-8 -*-
"""
Auto-create a staging table (all TEXT columns) from a CSV header and bulk load it.

Usage:
  python scripts/sql/day5_autoload_csv.py \
    --csv datasets/ecommerce_sales.csv --schema stage --table raw_ecommerce [--replace]

Requires: psycopg (v3). Install in your venv:  pip install "psycopg[binary]"
"""
import argparse, csv, os, re, sys
from pathlib import Path

def snake(s: str) -> str:
    s = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', s.strip())
    s = re.sub(r'[^a-zA-Z0-9_]+', '_', s)
    return s.strip('_').lower()

def connect():
    import psycopg
    d = {}
    if os.getenv("PGHOST"):  d["host"] = os.getenv("PGHOST")
    if os.getenv("PGPORT"):  d["port"] = int(os.getenv("PGPORT"))
    if os.getenv("PGUSER"):  d["user"] = os.getenv("PGUSER")
    if os.getenv("PGPASSWORD"): d["password"] = os.getenv("PGPASSWORD")
    d["dbname"] = os.getenv("PGDATABASE", "postgres")
    # If using socket (no host), drop sslmode to avoid empty value issues
    if os.getenv("PGHOST") and os.getenv("PGSSLMODE"):
        d["sslmode"] = os.getenv("PGSSLMODE")
    import psycopg
    return psycopg.connect(**d)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", required=True)
    ap.add_argument("--schema", default="stage")
    ap.add_argument("--table",  default="raw_ecommerce")
    ap.add_argument("--replace", action="store_true", help="DROP TABLE first")
    args = ap.parse_args()

    csv_path = Path(args.csv)
    if not csv_path.exists():
        sys.exit(f"CSV not found: {csv_path}")

    # Read header (utf-8-sig handles BOM)
    with csv_path.open(newline='', encoding="utf-8-sig") as f:
        header = next(csv.reader(f))
    cols = [snake(c) for c in header]
    if len(set(cols)) != len(cols):
        sys.exit(f"Duplicate column names after normalization: {cols}")

    create_schema = f"CREATE SCHEMA IF NOT EXISTS {args.schema};"
    drop_table     = f"DROP TABLE IF EXISTS {args.schema}.{args.table};"
    create_table   = f"CREATE TABLE {args.schema}.{args.table} (row_id BIGSERIAL PRIMARY KEY, " + \
                     ", ".join(f"{c} TEXT" for c in cols) + ");"
    copy_sql       = f"COPY {args.schema}.{args.table} ({', '.join(cols)}) FROM STDIN WITH (FORMAT csv, HEADER true)"

    import psycopg
    conn = connect()
    with conn.cursor() as cur:
        cur.execute(create_schema)
        if args.replace:
            cur.execute(drop_table)
        # create only if absent when not replacing
        if args.replace:
            cur.execute(create_table)
        else:
            cur.execute(f"SELECT to_regclass(%s)", (f"{args.schema}.{args.table}",))
            exists = cur.fetchone()[0] is not None
            if not exists:
                cur.execute(create_table)

        with csv_path.open("r", encoding="utf-8-sig") as f:
            cur.copy(copy_sql, f.read())

        # count rows for feedback
        cur.execute(f"SELECT COUNT(*) FROM {args.schema}.{args.table}")
        n = cur.fetchone()[0]

    conn.commit(); conn.close()
    print(f"✅ Loaded {n} rows from {csv_path} into {args.schema}.{args.table} with {len(cols)} columns.")

if __name__ == "__main__":
    main()
PY
