SELECT kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
     ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'your_table_name'
  AND tc.constraint_type = 'PRIMARY KEY';

