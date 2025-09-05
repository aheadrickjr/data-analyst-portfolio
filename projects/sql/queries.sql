-- consolidated on 2025-09-06T01:30:18+08:00

-- ==================================================
-- File: meta_find_tablebyname.sql
-- ==================================================

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name ILIKE '%customer%';



-- ==================================================
-- File: meta_findall_tables.sql
-- ==================================================

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
  AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;


-- ==================================================
-- File: meta_findidx_table.sql
-- ==================================================

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'your_table_name';


-- ==================================================
-- File: meta_fndPrimKeys_table.sql
-- ==================================================

SELECT kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
     ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'your_table_name'
  AND tc.constraint_type = 'PRIMARY KEY';



-- ==================================================
-- File: meta_fndcolname_alltab.sql
-- ==================================================

--Search for a Column Name Across All Tables
SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE column_name ILIKE '%email%';


-- ==================================================
-- File: meta_forkeyrelated.sql
-- ==================================================

SELECT
    tc.table_name AS source_table,
    kcu.column_name AS source_column,
    ccu.table_name AS target_table,
    ccu.column_name AS target_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
     ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
     ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY';


-- ==================================================
-- File: meta_listallcols_table.sql
-- ==================================================

SELECT column_name, data_type, is_nullable, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'your_table_name';



-- ==================================================
-- File: meta_rowcnt_table.sql
-- ==================================================

SELECT relname AS table_name,
       reltuples::BIGINT AS estimated_rows
FROM pg_class
WHERE relkind = 'r'
ORDER BY estimated_rows DESC;


