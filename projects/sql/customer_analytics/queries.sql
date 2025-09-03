-- Top 10 Customers by Total Spend
SELECT CustomerID, SUM(UnitPrice * Quantity) AS TotalSpent
FROM ecommerce_sales
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;

-- Monthly Sales Trend
SELECT DATE_TRUNC('month', InvoiceDate) AS Month, SUM(UnitPrice * Quantity) AS Revenue
FROM ecommerce_sales
GROUP BY Month
ORDER BY Month;

-- Repeat Buyers
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Orders
FROM ecommerce_sales
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) > 1
ORDER BY Orders DESC
LIMIT 10;


