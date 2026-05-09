-- ============================================================
-- PROJECT: E-Commerce Funnel & Revenue Analysis
-- Author  : Mohd Zaid Ahmad | Business Analyst
-- Tools   : SQL (PostgreSQL-compatible syntax)
-- Source  : Simulated retail dataset (~50K order records)
-- Purpose : Uncover revenue drivers, funnel drop-offs,
--           cohort retention, and product performance
-- ============================================================

-- ─────────────────────────────────────────────
-- SECTION 0: SCHEMA SETUP
-- ─────────────────────────────────────────────

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS sessions CASCADE;

CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100),
    email           VARCHAR(150),
    city            VARCHAR(80),
    state           VARCHAR(50),
    segment         VARCHAR(30),         -- 'Consumer', 'Corporate', 'Home Office'
    signup_date     DATE,
    acquisition_channel VARCHAR(40)      -- 'Organic','Paid Search','Referral','Social'
);

CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(200),
    category        VARCHAR(80),
    sub_category    VARCHAR(80),
    brand           VARCHAR(80),
    cost_price      NUMERIC(10,2),
    list_price      NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INT REFERENCES customers(customer_id),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(40),         -- 'Standard','Second Class','First Class','Same Day'
    order_status    VARCHAR(20),         -- 'Completed','Returned','Cancelled'
    discount_pct    NUMERIC(5,2) DEFAULT 0,
    coupon_used     BOOLEAN DEFAULT FALSE
);

CREATE TABLE order_items (
    item_id         SERIAL PRIMARY KEY,
    order_id        INT REFERENCES orders(order_id),
    product_id      INT REFERENCES products(product_id),
    quantity        INT,
    unit_price      NUMERIC(10,2),
    discount_amount NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE sessions (
    session_id      SERIAL PRIMARY KEY,
    customer_id     INT REFERENCES customers(customer_id),
    session_date    DATE,
    device_type     VARCHAR(20),         -- 'Mobile','Desktop','Tablet'
    channel         VARCHAR(40),
    pages_viewed    INT,
    added_to_cart   BOOLEAN DEFAULT FALSE,
    checkout_started BOOLEAN DEFAULT FALSE,
    purchased       BOOLEAN DEFAULT FALSE,
    session_duration_mins INT
);

-- ─────────────────────────────────────────────
-- SEED DATA (Representative sample)
-- ─────────────────────────────────────────────

INSERT INTO customers (customer_name, email, city, state, segment, signup_date, acquisition_channel) VALUES
('Riya Sharma',      'riya.s@email.com',    'Mumbai',    'Maharashtra', 'Consumer',   '2022-01-15', 'Organic'),
('Aditya Verma',     'aditya.v@email.com',  'Delhi',     'Delhi',       'Corporate',  '2022-02-01', 'Paid Search'),
('Priya Nair',       'priya.n@email.com',   'Bangalore', 'Karnataka',   'Consumer',   '2022-03-10', 'Social'),
('Rohit Gupta',      'rohit.g@email.com',   'Chennai',   'Tamil Nadu',  'Home Office','2022-04-05', 'Referral'),
('Sneha Kapoor',     'sneha.k@email.com',   'Hyderabad', 'Telangana',   'Consumer',   '2022-05-20', 'Organic'),
('Vikram Singh',     'vikram.s@email.com',  'Pune',      'Maharashtra', 'Corporate',  '2022-06-12', 'Paid Search'),
('Anjali Mehta',     'anjali.m@email.com',  'Kolkata',   'West Bengal', 'Consumer',   '2022-07-08', 'Social'),
('Suresh Iyer',      'suresh.i@email.com',  'Ahmedabad', 'Gujarat',     'Home Office','2022-08-25', 'Referral'),
('Kavita Joshi',     'kavita.j@email.com',  'Jaipur',    'Rajasthan',   'Consumer',   '2022-09-14', 'Organic'),
('Manish Tiwari',    'manish.t@email.com',  'Lucknow',   'Uttar Pradesh','Corporate', '2022-10-30', 'Paid Search'),
('Deepa Reddy',      'deepa.r@email.com',   'Vizag',     'Andhra Pradesh','Consumer', '2022-11-18', 'Social'),
('Arjun Patel',      'arjun.p@email.com',   'Surat',     'Gujarat',     'Consumer',   '2022-12-05', 'Organic'),
('Nisha Bose',       'nisha.b@email.com',   'Bhopal',    'Madhya Pradesh','Home Office','2023-01-22','Referral'),
('Karan Malhotra',   'karan.m@email.com',   'Chandigarh','Punjab',      'Corporate',  '2023-02-14', 'Paid Search'),
('Pooja Desai',      'pooja.d@email.com',   'Nagpur',    'Maharashtra', 'Consumer',   '2023-03-09', 'Organic'),
('Rahul Saxena',     'rahul.sx@email.com',  'Indore',    'Madhya Pradesh','Consumer', '2023-04-17', 'Social'),
('Meera Krishnan',   'meera.k@email.com',   'Coimbatore','Tamil Nadu',  'Corporate',  '2023-05-28', 'Referral'),
('Sameer Khan',      'sameer.k@email.com',  'Patna',     'Bihar',       'Consumer',   '2023-06-11', 'Organic'),
('Tanvi Rao',        'tanvi.r@email.com',   'Mysore',    'Karnataka',   'Home Office','2023-07-03', 'Paid Search'),
('Harsh Agarwal',    'harsh.a@email.com',   'Varanasi',  'Uttar Pradesh','Consumer',  '2023-08-19', 'Social');

INSERT INTO products (product_name, category, sub_category, brand, cost_price, list_price) VALUES
('Samsung 65" 4K Smart TV',      'Electronics',  'Televisions',     'Samsung',   28000, 42000),
('Apple iPhone 15 128GB',        'Electronics',  'Smartphones',     'Apple',     55000, 75000),
('Sony WH-1000XM5 Headphones',   'Electronics',  'Audio',           'Sony',       8000, 14000),
('Lenovo IdeaPad 3 Laptop',      'Electronics',  'Laptops',         'Lenovo',    28000, 38000),
('Prestige Induction Cooktop',   'Home & Kitchen','Appliances',     'Prestige',   2800,  4500),
('Nilkamal Freedom Cabinet',     'Furniture',    'Storage',         'Nilkamal',   5500,  9200),
('Raymond Formal Shirt',         'Apparel',      'Men\'s Clothing', 'Raymond',     600,  1400),
('Levi\'s 511 Slim Jeans',       'Apparel',      'Men\'s Clothing', 'Levi\'s',    1800,  3200),
('Nike Air Max 270',             'Footwear',     'Sports',          'Nike',       4200,  8500),
('Adidas Ultraboost 22',         'Footwear',     'Sports',          'Adidas',     5000,  9800),
('Himalaya Face Wash 150ml',     'Beauty',       'Skincare',        'Himalaya',    120,   280),
('Mamaearth Onion Shampoo',      'Beauty',       'Haircare',        'Mamaearth',   180,   399),
('Classmate Spiral Notebook 6pk','Stationery',   'Notebooks',       'Classmate',    90,   210),
('Casio FX-991EX Calculator',    'Stationery',   'Electronics',     'Casio',       650,  1250),
('Pigeon Non-Stick Kadai 28cm',  'Home & Kitchen','Cookware',       'Pigeon',     1100,  1999),
('Urban Ladder Coffee Table',    'Furniture',    'Tables',          'Urban Ladder',6000, 11500),
('Woodland Trekking Shoes',      'Footwear',     'Outdoor',         'Woodland',   2800,  5600),
('Boat Rockerz 450 BT Headphone','Electronics',  'Audio',           'Boat',        900,  1999),
('Milton Steel Water Bottle',    'Home & Kitchen','Drinkware',      'Milton',      350,   799),
('Wildcraft Backpack 45L',       'Accessories',  'Bags',            'Wildcraft',  1800,  3499);

INSERT INTO orders (customer_id, order_date, ship_date, ship_mode, order_status, discount_pct, coupon_used) VALUES
(1,  '2023-01-05', '2023-01-08', 'Standard',    'Completed', 0,    FALSE),
(2,  '2023-01-12', '2023-01-13', 'First Class', 'Completed', 5,    TRUE),
(3,  '2023-01-18', '2023-01-22', 'Standard',    'Returned',  0,    FALSE),
(4,  '2023-01-25', '2023-01-28', 'Second Class','Completed', 10,   TRUE),
(5,  '2023-02-03', '2023-02-07', 'Standard',    'Completed', 0,    FALSE),
(6,  '2023-02-10', '2023-02-11', 'Same Day',    'Completed', 15,   TRUE),
(7,  '2023-02-17', '2023-02-21', 'Standard',    'Cancelled', 0,    FALSE),
(8,  '2023-02-24', '2023-02-27', 'Second Class','Completed', 5,    FALSE),
(9,  '2023-03-02', '2023-03-06', 'Standard',    'Completed', 0,    FALSE),
(10, '2023-03-09', '2023-03-10', 'First Class', 'Completed', 10,   TRUE),
(1,  '2023-03-16', '2023-03-20', 'Standard',    'Completed', 0,    FALSE),
(2,  '2023-03-23', '2023-03-24', 'Same Day',    'Completed', 20,   TRUE),
(11, '2023-04-01', '2023-04-05', 'Standard',    'Completed', 0,    FALSE),
(12, '2023-04-08', '2023-04-12', 'Second Class','Returned',  5,    FALSE),
(13, '2023-04-15', '2023-04-18', 'Standard',    'Completed', 0,    FALSE),
(14, '2023-04-22', '2023-04-23', 'First Class', 'Completed', 10,   TRUE),
(15, '2023-05-01', '2023-05-05', 'Standard',    'Completed', 0,    FALSE),
(16, '2023-05-08', '2023-05-12', 'Standard',    'Completed', 5,    FALSE),
(3,  '2023-05-15', '2023-05-16', 'Same Day',    'Completed', 0,    FALSE),
(5,  '2023-05-22', '2023-05-26', 'Standard',    'Cancelled', 0,    FALSE),
(17, '2023-06-01', '2023-06-05', 'Standard',    'Completed', 0,    FALSE),
(18, '2023-06-08', '2023-06-09', 'First Class', 'Completed', 10,   TRUE),
(19, '2023-06-15', '2023-06-19', 'Standard',    'Completed', 0,    FALSE),
(20, '2023-06-22', '2023-06-23', 'Same Day',    'Completed', 5,    FALSE),
(1,  '2023-07-01', '2023-07-05', 'Standard',    'Completed', 0,    FALSE),
(6,  '2023-07-08', '2023-07-09', 'First Class', 'Completed', 15,   TRUE),
(9,  '2023-07-15', '2023-07-19', 'Standard',    'Completed', 0,    FALSE),
(11, '2023-07-22', '2023-07-26', 'Second Class','Returned',  0,    FALSE),
(13, '2023-08-01', '2023-08-05', 'Standard',    'Completed', 10,   TRUE),
(2,  '2023-08-08', '2023-08-09', 'Same Day',    'Completed', 0,    FALSE);

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_amount) VALUES
(1,  1,  1, 42000,  0),
(1,  11, 2,   280,  0),
(2,  2,  1, 75000, 3750),
(3,  9,  1,  8500,  0),
(4,  5,  1,  4500,  450),
(4,  19, 2,   799,   80),
(5,  3,  1, 14000,  0),
(6,  4,  1, 38000, 5700),
(7,  7,  3,  1400,  0),
(8,  10, 1,  9800,  490),
(9,  12, 2,   399,   0),
(10, 8,  2,  3200,  640),
(11, 18, 1,  1999,  0),
(11, 13, 3,   210,  0),
(12, 4,  1, 38000, 1900),
(13, 6,  1,  9200,  0),
(14, 2,  1, 75000, 7500),
(15, 15, 1,  1999,  0),
(16, 17, 1,  5600,  280),
(17, 20, 2,  3499,  0),
(18, 1,  1, 42000, 4200),
(19, 16, 1, 11500,  0),
(20, 9,  1,  8500,  0),
(21, 3,  2, 14000,  0),
(22, 14, 1,  1250,  125),
(23, 5,  2,  4500,  0),
(24, 11, 4,   280,   56),
(25, 7,  2,  1400,  0),
(26, 10, 1,  9800, 1470),
(27, 18, 2,  1999,  0),
(28, 6,  1,  9200,  0),
(29, 2,  1, 75000, 7500),
(30, 4,  1, 38000,  0);

INSERT INTO sessions (customer_id, session_date, device_type, channel, pages_viewed, added_to_cart, checkout_started, purchased, session_duration_mins) VALUES
(1,  '2023-01-04', 'Desktop', 'Organic',     8,  TRUE,  TRUE,  TRUE,  22),
(2,  '2023-01-11', 'Mobile',  'Paid Search', 5,  TRUE,  TRUE,  TRUE,  18),
(3,  '2023-01-17', 'Mobile',  'Social',      4,  TRUE,  FALSE, FALSE,  9),
(4,  '2023-01-24', 'Desktop', 'Referral',    6,  TRUE,  TRUE,  TRUE,  15),
(5,  '2023-02-02', 'Tablet',  'Organic',     7,  TRUE,  TRUE,  TRUE,  20),
(6,  '2023-02-09', 'Desktop', 'Paid Search', 9,  TRUE,  TRUE,  TRUE,  28),
(7,  '2023-02-16', 'Mobile',  'Social',      3,  TRUE,  FALSE, FALSE,  7),
(8,  '2023-02-23', 'Desktop', 'Referral',    5,  TRUE,  TRUE,  TRUE,  16),
(9,  '2023-03-01', 'Mobile',  'Organic',     6,  TRUE,  TRUE,  TRUE,  19),
(10, '2023-03-08', 'Desktop', 'Paid Search', 10, TRUE,  TRUE,  TRUE,  35),
(11, '2023-03-15', 'Mobile',  'Social',      2,  FALSE, FALSE, FALSE,  4),
(12, '2023-03-22', 'Tablet',  'Organic',     4,  TRUE,  FALSE, FALSE,  11),
(13, '2023-04-01', 'Mobile',  'Organic',     3,  FALSE, FALSE, FALSE,  6),
(14, '2023-04-08', 'Desktop', 'Paid Search', 8,  TRUE,  TRUE,  TRUE,  24),
(15, '2023-04-14', 'Mobile',  'Referral',    5,  TRUE,  TRUE,  TRUE,  14),
(16, '2023-05-07', 'Desktop', 'Social',      6,  TRUE,  TRUE,  TRUE,  21),
(17, '2023-06-01', 'Mobile',  'Organic',     4,  TRUE,  FALSE, FALSE,  8),
(18, '2023-06-07', 'Desktop', 'Paid Search', 7,  TRUE,  TRUE,  TRUE,  26),
(19, '2023-06-14', 'Tablet',  'Organic',     5,  TRUE,  TRUE,  TRUE,  18),
(20, '2023-06-21', 'Mobile',  'Social',      3,  TRUE,  TRUE,  TRUE,  12);
-- ============================================================
-- E-COMMERCE FUNNEL & REVENUE ANALYSIS
-- FILE 2: Business Analysis Queries
-- Author : Mohd Zaid Ahmad | Business Analyst
-- ============================================================

-- ─────────────────────────────────────────────
-- ANALYSIS 1: MONTHLY REVENUE TREND
-- Business Question: How is revenue growing month-over-month?
-- ─────────────────────────────────────────────

SELECT
    TO_CHAR(o.order_date, 'YYYY-MM')                          AS month,
    COUNT(DISTINCT o.order_id)                                AS total_orders,
    COUNT(DISTINCT o.customer_id)                             AS unique_customers,
    SUM(oi.quantity * oi.unit_price - oi.discount_amount)     AS gross_revenue,
    SUM(oi.quantity * oi.unit_price)                          AS revenue_before_discount,
    SUM(oi.discount_amount)                                   AS total_discounts,
    ROUND(SUM(oi.discount_amount) * 100.0 /
          NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2)     AS discount_rate_pct,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount) /
          NULLIF(COUNT(DISTINCT o.order_id), 0), 2)           AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;


-- ─────────────────────────────────────────────
-- ANALYSIS 2: CONVERSION FUNNEL BY CHANNEL
-- Business Question: Which channel converts best?
-- ─────────────────────────────────────────────

SELECT
    channel,
    COUNT(*)                                                   AS total_sessions,
    COUNT(*) FILTER (WHERE added_to_cart   = TRUE)            AS add_to_cart,
    COUNT(*) FILTER (WHERE checkout_started= TRUE)            AS checkout_started,
    COUNT(*) FILTER (WHERE purchased       = TRUE)            AS purchases,
    ROUND(COUNT(*) FILTER (WHERE added_to_cart    = TRUE) * 100.0 / COUNT(*), 1) AS cart_rate_pct,
    ROUND(COUNT(*) FILTER (WHERE checkout_started = TRUE) * 100.0 /
          NULLIF(COUNT(*) FILTER (WHERE added_to_cart = TRUE), 0), 1)            AS cart_to_checkout_pct,
    ROUND(COUNT(*) FILTER (WHERE purchased = TRUE) * 100.0 /
          NULLIF(COUNT(*) FILTER (WHERE checkout_started = TRUE), 0), 1)         AS checkout_to_purchase_pct,
    ROUND(COUNT(*) FILTER (WHERE purchased = TRUE) * 100.0 / COUNT(*), 1)        AS overall_cvr_pct
FROM sessions
GROUP BY channel
ORDER BY overall_cvr_pct DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 3: PRODUCT PROFITABILITY RANKING
-- Business Question: Which products drive the most margin?
-- ─────────────────────────────────────────────

SELECT
    p.product_name,
    p.category,
    p.sub_category,
    SUM(oi.quantity)                                                          AS units_sold,
    SUM(oi.quantity * oi.unit_price - oi.discount_amount)                    AS net_revenue,
    SUM(oi.quantity * p.cost_price)                                          AS total_cogs,
    SUM(oi.quantity * oi.unit_price - oi.discount_amount
        - oi.quantity * p.cost_price)                                        AS gross_profit,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount
              - oi.quantity * p.cost_price) * 100.0 /
          NULLIF(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 0), 1) AS gross_margin_pct,
    RANK() OVER (ORDER BY
        SUM(oi.quantity * oi.unit_price - oi.discount_amount
            - oi.quantity * p.cost_price) DESC)                              AS profit_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id   = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category, p.sub_category
ORDER BY gross_profit DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 4: CUSTOMER SEGMENTATION (RFM MODEL)
-- Business Question: Who are our most valuable customers?
-- RFM = Recency, Frequency, Monetary
-- ─────────────────────────────────────────────

WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        c.acquisition_channel,
        MAX(o.order_date)                                         AS last_order_date,
        COUNT(DISTINCT o.order_id)                                AS frequency,
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)    AS monetary
    FROM customers c
    JOIN orders o    ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, c.segment, c.acquisition_channel
),
rfm_scored AS (
    SELECT *,
        DATE '2023-09-01' - last_order_date                      AS recency_days,
        NTILE(4) OVER (ORDER BY DATE '2023-09-01' - last_order_date ASC)  AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC)                   AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC)                    AS m_score
    FROM rfm_base
)
SELECT
    customer_id,
    customer_name,
    segment,
    acquisition_channel,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score, f_score, m_score,
    r_score + f_score + m_score                                   AS rfm_total,
    CASE
        WHEN r_score + f_score + m_score >= 10 THEN 'Champion'
        WHEN r_score + f_score + m_score >= 8  THEN 'Loyal Customer'
        WHEN r_score + f_score + m_score >= 6  THEN 'Potential Loyalist'
        WHEN r_score >= 3 AND f_score <= 2      THEN 'New Customer'
        WHEN r_score <= 2 AND m_score >= 3      THEN 'At Risk'
        ELSE 'Needs Attention'
    END                                                           AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 5: COHORT RETENTION ANALYSIS
-- Business Question: Do customers return after first purchase?
-- ─────────────────────────────────────────────

WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date)                              AS cohort_date,
        DATE_TRUNC('month', MIN(order_date))         AS cohort_month
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
order_months AS (
    SELECT
        o.customer_id,
        fp.cohort_month,
        DATE_TRUNC('month', o.order_date)            AS order_month,
        EXTRACT(MONTH FROM AGE(
            DATE_TRUNC('month', o.order_date),
            fp.cohort_month))::INT                   AS month_number
    FROM orders o
    JOIN first_purchase fp ON o.customer_id = fp.customer_id
    WHERE o.order_status = 'Completed'
)
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM')                AS cohort,
    COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 0)  AS m0_customers,
    COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 1)  AS m1_retained,
    COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 2)  AS m2_retained,
    COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 3)  AS m3_retained,
    ROUND(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 1) * 100.0 /
          NULLIF(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 0), 0), 1) AS m1_retention_pct,
    ROUND(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 2) * 100.0 /
          NULLIF(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 0), 0), 1) AS m2_retention_pct,
    ROUND(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 3) * 100.0 /
          NULLIF(COUNT(DISTINCT customer_id) FILTER (WHERE month_number = 0), 0), 1) AS m3_retention_pct
FROM order_months
GROUP BY cohort_month
ORDER BY cohort_month;


-- ─────────────────────────────────────────────
-- ANALYSIS 6: RETURN & CANCELLATION ANALYSIS
-- Business Question: What's causing revenue leakage?
-- ─────────────────────────────────────────────

SELECT
    p.category,
    COUNT(*) FILTER (WHERE o.order_status = 'Completed')  AS completed_orders,
    COUNT(*) FILTER (WHERE o.order_status = 'Returned')   AS returned_orders,
    COUNT(*) FILTER (WHERE o.order_status = 'Cancelled')  AS cancelled_orders,
    ROUND(COUNT(*) FILTER (WHERE o.order_status = 'Returned') * 100.0 /
          NULLIF(COUNT(*), 0), 1)                          AS return_rate_pct,
    ROUND(COUNT(*) FILTER (WHERE o.order_status = 'Cancelled') * 100.0 /
          NULLIF(COUNT(*), 0), 1)                          AS cancel_rate_pct,
    SUM(oi.quantity * oi.unit_price) FILTER
        (WHERE o.order_status = 'Returned')                AS returned_revenue_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 7: DEVICE & CHANNEL PERFORMANCE
-- Business Question: Mobile vs Desktop — where should we invest?
-- ─────────────────────────────────────────────

SELECT
    s.device_type,
    COUNT(*)                                                      AS sessions,
    AVG(s.session_duration_mins)                                  AS avg_session_mins,
    ROUND(COUNT(*) FILTER (WHERE s.purchased = TRUE) * 100.0 /
          COUNT(*), 2)                                            AS cvr_pct,
    SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        FILTER (WHERE o.order_status = 'Completed')               AS attributed_revenue
FROM sessions s
LEFT JOIN orders o  ON s.customer_id = o.customer_id
                    AND o.order_date  = s.session_date + 1
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.device_type
ORDER BY cvr_pct DESC;
