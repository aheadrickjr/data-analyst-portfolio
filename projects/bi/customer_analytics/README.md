# Customer Analytics – ADS Notebook (Day 3)

This project demonstrates customer analytics using **PostgreSQL** and **Azure Data Studio Notebooks**.

## 📊 Objectives
The analysis answers three key business questions:

1. **Top 10 Customers by Spend**  
   Identify the highest-value customers by total revenue.

2. **Monthly Revenue Trend**  
   Track sales performance over time, with a line chart visualization.

3. **Repeat Buyers**  
   Highlight customers making multiple purchases (loyalty indicator).

---

## 🗄️ Dataset
- **Source:** `da.ecommerce_sales` table in the `de_portfolio` Postgres database  
- **Sample Size:** 199 records  
- **Fields:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country  

---

## 📓 Notebook
Notebook file:  
[`customer_analytics_notebook.ipynb`](./customer_analytics_notebook.ipynb)

- Written in **SQL** kernel  
- Runs queries directly against Postgres (`de_portfolio`)  
- Inline results included for reproducibility  

---

## 📸 Screenshots
Inline results captured from ADS Notebook:

- ![Notebook Screenshot 1](../../assets/screenshots/day3_customer_analytics_notebook-1.png)
- ![Notebook Screenshot 2](../../assets/screenshots/day3_customer_analytics_notebook-2.png)
- ![Notebook Screenshot (overview)](../../assets/screenshots/day3_customer_analytics_notebook.png)

---

## ✅ Insights
- Revenue is concentrated among a few high-value customers.  
- Monthly trends reveal fluctuations and potential seasonal patterns.  
- Repeat buyers provide strong opportunities for retention and upsell.  

---

## 🔜 Next Steps
- Extend queries to include **regional analysis** (by `Country`).  
- Build a **Power BI dashboard** (scheduled for Day 5–6).  
- Add Python EDA (Day 4 sprint).

