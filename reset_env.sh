# in repo root
sed -i 's/^PGHOST=.*/PGHOST=\/tmp/' .env
sed -i 's/^PGDATABASE=.*/PGDATABASE=de_portfolio/' .env   # or your chosen DB

# reload env into this shell
while IFS='=' read -r k v; do [[ -z "$k" || "$k" =~ ^\s*# ]] && continue; val="$(echo "${v:-}"|tr -d '\r')"; [[ -z "$val" ]] && unset "$k" || export "$k"="$val"; done < .env

# sanity check (should say: via socket in "/tmp")
psql -d "$PGDATABASE" -c '\conninfo'
