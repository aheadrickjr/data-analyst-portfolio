# from repo root
sed -i 's/^PGUSER=.*/PGUSER=arval/' .env
sed -i 's/^PGDATABASE=.*/PGDATABASE=postgres/' .env
sed -i 's/^PGHOST=.*/# PGHOST=/' .env
grep -q '^PGSSLMODE=' .env && sed -i 's/^PGSSLMODE=.*/PGSSLMODE=prefer/' .env || true

# load .env into current shell
while IFS='=' read -r k v; do
  [[ -z "$k" || "$k" =~ ^\s*# ]] && continue
  val="$(echo "${v:-}" | tr -d '\r')"
  if [[ -z "$val" ]]; then unset "$k"; else export "$k"="$val"; fi
done < .env

# sanity
psql -d "$PGDATABASE" -c '\conninfo'

# 1) VS Code: reopen the repo from WSL if needed
code .

# 2) Files exist?
ls -l .vscode/{settings.json,launch.json,tasks.json}
ls -l .venv/bin/python

# 3) New VS Code terminal → verify venv/python
which python
python -V
psql -d "$PGDATABASE" -c '\conninfo'   # sanity DB check (socket auth is fine)
