#!/usr/bin/env bash
set -euo pipefail

# load .env (unset empty values)
if [[ -f ".env" ]]; then
  while IFS='=' read -r k v; do
    [[ -z "${k:-}" || "$k" =~ ^\s*# ]] && continue
    val="$(echo "${v:-}" | tr -d '\r')"
    if [[ -z "$val" ]]; then unset "$k"; else export "$k"="$val"; fi
  done < .env
fi

usage(){ echo "Usage: $0 {tables_all|table_like|columns|column_like|pkeys|fkeys|indexes|rowcount} [-s schema] [-t table] [-l like]"; exit 1; }
[[ $# -lt 1 ]] && usage
ACTION="$1"; shift || true

SCHEMA="public"; TABLE=""; LIKE=""
while getopts "s:t:l:" opt; do
  case $opt in
    s) SCHEMA="$OPTARG" ;;
    t) TABLE="$OPTARG" ;;
    l) LIKE="$OPTARG" ;;
    *) usage ;;
  esac
done

SQL_DIR="projects/sql"
OUT_DIR="artifacts/day4"
mkdir -p "$OUT_DIR"

case "$ACTION" in
  tables_all)  FILE="meta_findall_tables.sql";    OUT="$OUT_DIR/tables.csv" ;;
  table_like)  FILE="meta_find_tablebyname.sql";  OUT="$OUT_DIR/tables_like.csv" ;;
  columns)     FILE="meta_listallcols_table.sql"; OUT="$OUT_DIR/columns_${TABLE:-table}.csv" ;;
  column_like) FILE="meta_fndcolname_alltab.sql"; OUT="$OUT_DIR/columns_like.csv" ;;
  pkeys)       FILE="meta_fndPrimKeys_table.sql"; OUT="$OUT_DIR/pkeys_${TABLE:-table}.csv" ;;
  fkeys)       FILE="meta_forkeyrelated.sql";     OUT="$OUT_DIR/fkeys.csv" ;;
  indexes)     FILE="meta_findidx_table.sql";     OUT="$OUT_DIR/indexes_${TABLE:-table}.csv" ;;
  rowcount)    FILE="meta_rowcnt_table.sql";      OUT="$OUT_DIR/rowcount_${TABLE:-table}.csv" ;;
  *) usage ;;
esac

# Prepend variable defaults so your SQL can use :schema/:table/:like if desired
TMP_SQL="$(mktemp)"; trap 'rm -f "$TMP_SQL"' EXIT
printf "\\set schema '%s'\\n\\set table '%s'\\n\\set like '%s'\\n" "$SCHEMA" "$TABLE" "$LIKE" > "$TMP_SQL"
cat "$SQL_DIR/$FILE" >> "$TMP_SQL"

# Build psql args (omit -h if PGHOST is empty/unset to use local socket)
PSQL_ARGS=()
if [[ -n "${PGHOST:-}" ]]; then
  PSQL_ARGS+=(-h "$PGHOST")
fi
PSQL_ARGS+=(-p "${PGPORT:-5432}" -U "${PGUSER:-arval}" -d "${PGDATABASE:-postgres}")

psql "${PSQL_ARGS[@]}" -f "$TMP_SQL" -A -F ',' -P footer=off > "$OUT"
echo "✅ Wrote $OUT"

