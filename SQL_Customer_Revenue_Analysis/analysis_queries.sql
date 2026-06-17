-- ============================================================
-- PROJECT: Customer Orders & Revenue Analysis
-- Author  :  Umar Adab | Business Analyst Portfolio
-- Tool    : SQLite / MySQL / PostgreSQL compatible
-- ============================================================
-- SCHEMA REFERENCE:
--   customers   (customer_id, customer_name, city, segment, join_date)
--   products    (product_id, product_name, category, unit_price)
--   orders      (order_id, customer_id, order_date, status)
--   order_items (item_id, order_id, product_id, quantity, discount_pct)
-- ============================================================


-- ============================================================
-- SECTION 1: BUSINESS OVERVIEW
-- ============================================================

-- Q1. Total number of orders by status
-- Business Use: Understand how many orders are completed vs pending vs cancelled
SELECT 
    status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- Q2. Total revenue generated (completed orders only)
-- Business Use: Top-line revenue figure for the period
SELECT 
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed';


-- Q3. Monthly order volume trend
-- Business Use: Identify peak and slow months for planning
SELECT 
    STRFTIME('%Y-%m', order_date) AS month,
    COUNT(order_id) AS orders_placed
FROM orders
GROUP BY month
ORDER BY month;


-- ============================================================
-- SECTION 2: CUSTOMER ANALYSIS
-- ============================================================

-- Q4. Top 5 customers by total revenue
-- Business Use: Identify high-value customers for retention focus
SELECT 
    c.customer_name,
    c.segment,
    c.city,
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
ORDER BY revenue DESC
LIMIT 5;


-- Q5. Revenue breakdown by customer segment
-- Business Use: Understand which segment drives the most business
SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.segment
ORDER BY total_revenue DESC;


-- Q6. Customers with more than 1 completed order (repeat buyers)
-- Business Use: Measure customer loyalty and repeat purchase rate
SELECT 
    c.customer_name,
    c.segment,
    COUNT(o.order_id) AS completed_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
HAVING completed_orders > 1
ORDER BY completed_orders DESC;


-- ============================================================
-- SECTION 3: PRODUCT & CATEGORY ANALYSIS
-- ============================================================

-- Q7. Best-selling products by quantity sold
-- Business Use: Identify fast-moving inventory
SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY total_quantity_sold DESC;


-- Q8. Revenue by product category
-- Business Use: See which categories contribute most to revenue
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS category_revenue,
    COUNT(DISTINCT o.order_id) AS orders_count
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY category_revenue DESC;


-- Q9. Average discount given per category
-- Business Use: Check if discounts are eating into margins
SELECT 
    p.category,
    ROUND(AVG(oi.discount_pct), 2) AS avg_discount_pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY avg_discount_pct DESC;


-- ============================================================
-- SECTION 4: OPERATIONAL INSIGHTS
-- ============================================================

-- Q10. Cancellation rate by customer segment
-- Business Use: Find which segment has quality/fulfilment issues
SELECT 
    c.segment,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id), 
        2
    ) AS cancellation_rate_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY cancellation_rate_pct DESC;


-- Q11. Revenue lost due to cancelled orders
-- Business Use: Quantify the business impact of cancellations
SELECT 
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS revenue_lost
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Cancelled';


-- Q12. City-wise order distribution
-- Business Use: Plan regional sales or marketing efforts
SELECT 
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * p.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.city
ORDER BY total_revenue DESC;
