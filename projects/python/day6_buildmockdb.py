import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Generate sample sales dataset
np.random.seed(42)
dates = pd.date_range("2024-01-01", "2024-12-31", freq="D")
regions = ["North", "South", "East", "West"]
products = [f"Product-{i}" for i in range(1, 11)]

data = []
for date in dates:
    for _ in range(np.random.randint(20, 40)):  # daily sales
        region = np.random.choice(regions)
        product = np.random.choice(products)
        qty = np.random.randint(1, 6)
        price = np.random.uniform(10, 200)
        revenue = round(qty * price, 2)
        data.append([date, region, product, qty, price, revenue])

df = pd.DataFrame(data, columns=["date", "region", "product", "quantity", "unit_price", "revenue"])

# Summaries
monthly_revenue = df.groupby(df['date'].dt.to_period("M")).revenue.sum().to_timestamp()
revenue_by_region = df.groupby("region").revenue.sum().sort_values(ascending=False)
top_products = df.groupby("product").revenue.sum().sort_values(ascending=False).head(5)

# Create "dashboard" style layout
plt.figure(figsize=(12, 8))

# Chart 1: Monthly revenue trend
plt.subplot(2, 2, 1)
monthly_revenue.plot(kind="line", marker="o")
plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")

# Chart 2: Revenue by region
plt.subplot(2, 2, 2)
revenue_by_region.plot(kind="bar", color="skyblue")
plt.title("Revenue by Region")
plt.xlabel("Region")
plt.ylabel("Revenue")

# Chart 3: Top products
plt.subplot(2, 1, 2)
top_products.plot(kind="bar", color="lightgreen")
plt.title("Top 5 Products by Revenue")
plt.xlabel("Product")
plt.ylabel("Revenue")

plt.tight_layout()
plt.savefig("artifacts/data_doesnt_lie_dashboard.png", dpi=150)
plt.close()

"artifacts/data_doesnt_lie_dashboard.png"
