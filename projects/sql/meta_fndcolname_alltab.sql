--Search for a Column Name Across All Tables
SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE column_name ILIKE '%email%';
