ed -i 's/^PGUSER=.*/PGUSER=arval/' .env
sed -i 's/^PGDATABASE=.*/PGDATABASE=postgres/' .env
sed -i 's/^PGHOST=.*/# PGHOST=/' .env
grep -q '^PGSSLMODE=' .env && sed -i 's/^PGSSLMODE=.*/PGSSLMODE=prefer/' .env || true

#
echo $WSL_DISTRO_NAME      # should print Ubuntu
which python               # …/data-analyst-portfolio/.venv/bin/python
python -V                  # 3.x
psql -d "$PGDATABASE" -c '\conninfo'

