# Stop on first error so we don't half-apply
psql -v ON_ERROR_STOP=1 -d de_portfolio -c "BEGIN;
DROP VIEW IF EXISTS bi.v_sales CASCADE;
DROP VIEW IF EXISTS bi.v_calendar CASCADE;
COMMIT;"
