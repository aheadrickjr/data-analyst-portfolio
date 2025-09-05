# sanity: see where you're connected (should be socket / user arval)
psql -d postgres -c '\conninfo'

# exports (adjust table names to your catalog)
./run_metadata_sql.sh tables_all
./run_metadata_sql.sh table_like -l '%customer%'
./run_metadata_sql.sh columns  -s public -t customers
./run_metadata_sql.sh indexes  -s public -t customers
./run_metadata_sql.sh pkeys    -s public -t customers
./run_metadata_sql.sh rowcount -s public -t customers
./run_metadata_sql.sh column_like -l '%email%'
./run_metadata_sql.sh fkeys -s public
