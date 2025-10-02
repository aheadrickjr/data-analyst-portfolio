psql -h 127.0.0.1 -p 5432 -U arval -d de_portfolio \
  -v ON_ERROR_STOP=1 \
  -f scripts/sql/tool_bi_views.sql
