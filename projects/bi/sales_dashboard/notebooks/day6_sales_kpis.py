df_sales = fetch_df("""
    SELECT sale_date, region, category, subcategory, brand, product_name, net_amount, quantity
    FROM bi.v_sales
    ORDER BY sale_date;
""")

daily = df_sales.groupby("sale_date", as_index=False).agg(total_sales=("net_amount", "sum"))
region = df_sales.groupby("region", as_index=False).agg(total_sales=("net_amount", "sum"))
category = df_sales.groupby("category", as_index=False).agg(total_sales=("net_amount", "sum"))
daily = daily.sort_values("sale_date")
daily["cumulative_sales"] = daily["total_sales"].cumsum()
