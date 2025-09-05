SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'your_table_name';
