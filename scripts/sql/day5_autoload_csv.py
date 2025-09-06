# scripts/sql/day5_autoload_csv.py
# -*- coding: utf-8 -*-
"""
Auto-create a staging table (all TEXT columns) from a CSV header and bulk load it.

Usage:
  python scripts/sql/day5_autoload_csv.py \
    --csv datasets/ecommerce_sales.csv --schema stage --table raw_ecommerce [--replace]

Requires: psycopg (v3) -> pip install "psycopg[binary]"
Reads connection info from env (.env). Defaults to /tmp unix socket for WSL.
"""

import argparse, csv, os, re, sys
from pathlib import Path

def snake(s: str) -> str:
    s = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s.strip())
    s = re.sub(r"[^a-zA-Z0-9_]+", "_", s)
    return s.strip("_").lower()

def conn_params():
    host = os.getenv("PGHOST") or "/tmp"   # works with your server
    d = {"dbname": os.getenv("PGDATABASE", "postgres")}
    if host: d["host"] = host
    if os.getenv("PGPORT"): d["port"] = int(os.getenv("PGPORT"))
    if os.getenv("PGUSER"): d["user"] = os.getenv("PGUSER")
    if os.getenv("PGPASSWORD"): d["password"] = os.getenv("PGPASSWORD")
    if host and not host.startswith("/"):
        ssl = os.getenv("PGSSLMODE")
        if ssl: d["sslmode"] = ssl
    return d

def connect():
    import psycopg
    d = conn_params()
    print(f"[autoload] Connecting with: {{k:d.get(k) for k in ('host','port','dbname','user')}}"
          .replace("d", "d"))  # cute trick to avoid printing twice
    return psycopg.connect(**d)

def sniff_header_and_delim(csv_path: Path):
    # sniff delimiter from a sample
    sample = csv_path.read_text(encoding="utf-8-sig", errors="ignore")[:16384]
    try:
        dialect = csv.Sniffer().sniff(sample, delimiters=[",",";","|","\t"])
        delim = dialect.delimiter
    except Exception:
        delim = ","  # fallback
    # read header using detected delimiter
    with csv_path.open(newline="", encoding="utf-8-sig") as f:
        reader = csv.reader(f, delimiter=delim)
        header = next(reader, [])
    return [snake(c) for c in header], delim

def count_data_rows(csv_path: Path):
    n = 0
    with csv_path.open("r", encoding="utf-8-sig", errors="ignore") as f:
        # skip header
        next(f, None)
        for line in f:
            if line.strip():
                n += 1
    return n

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", required=True)
    ap.add_argument("--schema", default="stage")
    ap.add_argument("--table", default="raw_ecommerce")
    ap.add_argument("--replace", action="store_true", help="DROP TABLE first")
    args = ap.parse_args()

    csv_path = Path(args.csv)
    if not csv_path.exists():
        sys.exit(f"CSV not found: {csv_path}")

    cols, delim = sniff_header_and_delim(csv_path)
    if not cols:
        sys.exit("Could not read header from CSV.")
    if len(set(cols)) != len(cols):
        sys.exit(f"Duplicate column names after normalization: {cols}")

    rows_to_import = count_data_rows(csv_path)
    print(f"[autoload] CSV delimiter='{delim}' | columns={len(cols)} | data_rows={rows_to_import}")

    create_schema = f"CREATE SCHEMA IF NOT EXISTS {args.schema};"
    drop_table = f"DROP TABLE IF EXISTS {args.schema}.{args.table};"
    create_table = (
        f"CREATE TABLE {args.schema}.{args.table} ("
        f"row_id BIGSERIAL PRIMARY KEY, "
        + ", ".join(f"{c} TEXT" for c in cols)
        + ");"
    )
    copy_sql = (
        f"COPY {args.schema}.{args.table} "
        f"({', '.join(cols)}) FROM STDIN WITH (FORMAT csv, HEADER true, DELIMITER '{delim}')"
    )

    import psycopg
    try:
        conn = connect()
        with conn.cursor() as cur:
            cur.execute(create_schema)
            if args.replace:
                cur.execute(drop_table)

            if args.replace:
                cur.execute(create_table)
            else:
                cur.execute("SELECT to_regclass(%s)", (f"{args.schema}.{args.table}",))
                exists = cur.fetchone()[0] is not None
                if not exists:
                    cur.execute(create_table)

            if rows_to_import == 0:
                print("⚠️  No data rows found after the header; skipping COPY.")
            else:
                with csv_path.open("r", encoding="utf-8-sig") as f:
                    cur.copy(copy_sql, f)

            cur.execute(f"SELECT COUNT(*) FROM {args.schema}.{args.table}")
            n = cur.fetchone()[0]

        conn.commit()
        print(f"✅ Loaded {n} rows from {csv_path} into {args.schema}.{args.table} with {len(cols)} columns.")
    except psycopg.OperationalError as e:
        sys.exit(
            "❌ Connection failed. If you see a socket like '/var/run/postgresql/.s.PGSQL.5432', "
            "set PGHOST=/tmp in your .env.\n"
            f"Error: {e}"
        )
    finally:
        try: conn.close()
        except Exception: pass

if __name__ == "__main__":
    main()
