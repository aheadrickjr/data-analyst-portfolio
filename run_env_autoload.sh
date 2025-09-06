# ensure env points to the DB you want (e.g., de_portfolio) and to the /tmp socket
sed -i 's/^PGDATABASE=.*/PGDATABASE=de_portfolio/' .env
sed -i 's|^PGHOST=.*|PGHOST=/tmp|' .env
# reload env
while IFS='=' read -r k v; do [[ -z "$k" || "$k" =~ ^\s*# ]] && continue; v="$(echo "${v:-}"|tr -d '\r')"; [[ -z "$v" ]] && unset "$k" || export "$k"="$v"; done < .env

python scripts/sql/day5_autoload_csv.py \
  --csv datasets/ecommerce_sales.csv \
  --schema stage --table raw_ecommerce --replace
