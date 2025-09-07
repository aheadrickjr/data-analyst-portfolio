psql -d "$PGDATABASE" -x -c "
  SELECT ordinal_position, column_name, data_type
  FROM information_schema.columns
  WHERE table_schema='stage' AND table_name='raw_ecommerce'
  ORDER BY ordinal_position;"

# compact list
psql -d "$PGDATABASE" -At -c "
  SELECT ordinal_position||': '||column_name
  FROM information_schema.columns
  WHERE table_schema='stage' AND table_name='raw_ecommerce'
  ORDER BY ordinal_position;"
