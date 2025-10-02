-- File: scripts/sql/create_reporting_user.sql
-- Run as superuser (arval) in psql or ADS.
CREATE ROLE bi_reader LOGIN PASSWORD 'ChangeMe_Strong!';
-- Optional: put BI objects into a dedicated schema
CREATE SCHEMA IF NOT EXISTS bi AUTHORIZATION arval;

-- Grant read on warehouse schemas
GRANT USAGE ON SCHEMA dwh TO bi_reader;
GRANT USAGE ON SCHEMA bi  TO bi_reader;

-- Grant SELECT on existing tables/views
GRANT SELECT ON ALL TABLES IN SCHEMA dwh TO bi_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA bi  TO bi_reader;

-- Make it stick for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA dwh GRANT SELECT ON TABLES TO bi_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA bi  GRANT SELECT ON TABLES TO bi_reader;

-- If you use materialized views:
GRANT SELECT ON ALL SEQUENCES IN SCHEMA dwh TO bi_reader;
