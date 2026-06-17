-- ============================================
-- Finance & Revenue Analytics
-- Author: Umar Adab | Business Analyst Portfolio
-- Purpose: Revenue analysis, customer segmentation, and operational insights
-- ============================================

-- 1. Total Revenue (Completed Orders)
SELECT 
    SUM(unit_price * quantity) AS total_revenue
FROM orders
WHERE order_status = 'Completed';

-- 2. Monthly Revenue Trends
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(unit_price * quantity) AS monthly_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY year, month
ORDER BY year, month;

-- 3. Top 10 Customers by Revenue
SELECT 
    customer_id,
    customer_name,
    SUM(unit_price * quantity) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id, customer_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 4. Revenue by Product Category
SELECT 
    product_category,
    SUM(unit_price * quantity) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY total_revenue DESC;

-- 5. Cancellation Rate by City
SELECT 
    city,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        (SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)::NUMERIC / COUNT(order_id)) * 100, 2
    ) AS cancellation_rate_pct
FROM orders
GROUP BY city
ORDER BY cancellation_rate_pct DESC;
