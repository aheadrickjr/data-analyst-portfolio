psql -d "$PGDATABASE" -A -F ',' -P footer=off -f scripts/sql/day6_dashboard_queries.sql \
> artifacts/day6/dashboard_exports.csv