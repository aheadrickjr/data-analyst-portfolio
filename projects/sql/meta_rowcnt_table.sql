SELECT relname AS table_name,
       reltuples::BIGINT AS estimated_rows
FROM pg_class
WHERE relkind = 'r'
ORDER BY estimated_rows DESC;

