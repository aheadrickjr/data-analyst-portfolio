cat > .vscode/tasks.json <<'JSON'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Day4: tables_all → CSV",
      "type": "shell",
      "command": "bash -lc './scripts/sql/run_metadata_sql.sh tables_all'"
    },
    {
      "label": "Day4: columns (public.customers) → CSV",
      "type": "shell",
      "command": "bash -lc './scripts/sql/run_metadata_sql.sh columns -s public -t customers'"
    },
    {
      "label": "Apply DDL: day5_create_tables.sql",
      "type": "shell",
      "command": "bash -lc 'psql -d \"$PGDATABASE\" -f scripts/sql/day5_create_tables.sql'",
      "options": { "env": { "PGDATABASE": "${env:PGDATABASE}" } },
      "problemMatcher": []
    },
    {
      "label": "Populate: day5_populate_dim_fact.sql",
      "type": "shell",
      "command": "bash -lc 'psql -d \"$PGDATABASE\" -f scripts/sql/day5_populate_dim_fact.sql'",
      "problemMatcher": []
    }
  ]
}
JSON
