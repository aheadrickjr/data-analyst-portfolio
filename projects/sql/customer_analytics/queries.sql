-- Top 10 customers by spend
SELECT CustomerID,
       ROUND(SUM(UnitPrice*Quantity)::numeric, 2) AS total_spent
FROM da.ecommerce_sales
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

-- Monthly revenue trend
SELECT DATE_TRUNC('month', InvoiceDate) AS month,
       ROUND(SUM(UnitPrice*Quantity)::numeric, 2) AS revenue
FROM da.ecommerce_sales
GROUP BY 1
ORDER BY 1;

-- Repeat buyers
SELECT CustomerID,
       COUNT(DISTINCT InvoiceNo) AS orders
FROM da.ecommerce_sales
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) > 1
ORDER BY orders DESC
LIMIT 10;
