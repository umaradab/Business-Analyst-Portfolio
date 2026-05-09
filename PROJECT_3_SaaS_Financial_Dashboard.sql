-- ============================================================
-- PROJECT: SaaS Financial Performance & Unit Economics Dashboard
-- Author  : Mohd Zaid Ahmad | Business Analyst
-- Tools   : SQL (PostgreSQL-compatible syntax)
-- Context : FP&A / Finance Analytics — as done at Oracle,
--           Salesforce, or any SaaS-scale company
-- Purpose : MRR/ARR growth, churn, CAC, LTV, cohort revenue,
--           and P&L line-item analysis
-- ============================================================

-- ─────────────────────────────────────────────
-- SECTION 0: SCHEMA SETUP
-- ─────────────────────────────────────────────

DROP TABLE IF EXISTS revenue_transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS expense_ledger CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS plans CASCADE;

CREATE TABLE plans (
    plan_id         SERIAL PRIMARY KEY,
    plan_name       VARCHAR(50),        -- 'Starter','Growth','Professional','Enterprise'
    billing_cycle   VARCHAR(10),        -- 'Monthly','Annual'
    monthly_price   NUMERIC(10,2),
    annual_price    NUMERIC(10,2)
);

CREATE TABLE accounts (
    account_id      SERIAL PRIMARY KEY,
    company_name    VARCHAR(100),
    industry        VARCHAR(60),
    company_size    VARCHAR(20),        -- 'SMB','Mid-Market','Enterprise'
    country         VARCHAR(50),
    acquisition_channel VARCHAR(40),   -- 'Outbound','Inbound','Partnership','Trial'
    signup_date     DATE,
    csm_name        VARCHAR(80),        -- Customer Success Manager
    is_churned      BOOLEAN DEFAULT FALSE,
    churn_date      DATE
);

CREATE TABLE subscriptions (
    sub_id          SERIAL PRIMARY KEY,
    account_id      INT REFERENCES accounts(account_id),
    plan_id         INT REFERENCES plans(plan_id),
    start_date      DATE,
    end_date        DATE,
    mrr             NUMERIC(10,2),      -- Monthly Recurring Revenue
    arr             NUMERIC(10,2),      -- Annual Recurring Revenue
    seats           INT,
    discount_pct    NUMERIC(5,2) DEFAULT 0,
    status          VARCHAR(20)         -- 'Active','Churned','Upgraded','Downgraded'
);

CREATE TABLE revenue_transactions (
    txn_id          SERIAL PRIMARY KEY,
    account_id      INT REFERENCES accounts(account_id),
    txn_date        DATE,
    txn_type        VARCHAR(30),        -- 'New Biz','Expansion','Contraction','Churn','Renewal'
    amount          NUMERIC(12,2),
    seats_delta     INT DEFAULT 0
);

CREATE TABLE expense_ledger (
    expense_id      SERIAL PRIMARY KEY,
    expense_date    DATE,
    category        VARCHAR(60),        -- 'Sales','Marketing','R&D','G&A','Customer Success'
    sub_category    VARCHAR(80),
    amount          NUMERIC(12,2),
    is_cogs         BOOLEAN DEFAULT FALSE  -- TRUE = Cost of Revenue
);

-- ─────────────────────────────────────────────
-- SEED DATA
-- ─────────────────────────────────────────────

INSERT INTO plans (plan_name, billing_cycle, monthly_price, annual_price) VALUES
('Starter',      'Monthly', 2999,  NULL),
('Starter',      'Annual',  NULL,  29988),
('Growth',       'Monthly', 7999,  NULL),
('Growth',       'Annual',  NULL,  79990),
('Professional', 'Monthly', 18999, NULL),
('Professional', 'Annual',  NULL,  189990),
('Enterprise',   'Monthly', 49999, NULL),
('Enterprise',   'Annual',  NULL,  499990);

INSERT INTO accounts (company_name, industry, company_size, country, acquisition_channel, signup_date, csm_name, is_churned, churn_date) VALUES
('Zomato',          'Food Tech',     'Enterprise',  'India',    'Inbound',    '2022-01-15', 'Rahul Vyas',    FALSE, NULL),
('Razorpay',        'FinTech',       'Mid-Market',  'India',    'Outbound',   '2022-02-10', 'Priya Sood',    FALSE, NULL),
('CRED',            'FinTech',       'Mid-Market',  'India',    'Partnership','2022-03-05', 'Rahul Vyas',    FALSE, NULL),
('Meesho',          'E-Commerce',    'Mid-Market',  'India',    'Trial',      '2022-04-20', 'Priya Sood',    FALSE, NULL),
('Urban Company',   'Services',      'SMB',         'India',    'Inbound',    '2022-05-01', 'Ankit Mehta',   FALSE, NULL),
('Freshworks',      'B2B SaaS',      'Enterprise',  'India',    'Outbound',   '2022-06-10', 'Rahul Vyas',    FALSE, NULL),
('Groww',           'FinTech',       'Mid-Market',  'India',    'Inbound',    '2022-07-15', 'Priya Sood',    TRUE,  '2023-07-31'),
('Lenskart',        'Retail',        'Mid-Market',  'India',    'Outbound',   '2022-08-05', 'Ankit Mehta',   FALSE, NULL),
('BharatPe',        'FinTech',       'SMB',         'India',    'Trial',      '2022-09-20', 'Rahul Vyas',    TRUE,  '2023-06-30'),
('Dunzo',           'Logistics',     'SMB',         'India',    'Inbound',    '2022-10-10', 'Priya Sood',    TRUE,  '2023-04-30'),
('PhonePe',         'FinTech',       'Enterprise',  'India',    'Partnership','2022-11-01', 'Rahul Vyas',    FALSE, NULL),
('Swiggy',          'Food Tech',     'Enterprise',  'India',    'Outbound',   '2022-12-15', 'Ankit Mehta',   FALSE, NULL),
('Nykaa',           'Retail',        'Mid-Market',  'India',    'Inbound',    '2023-01-10', 'Priya Sood',    FALSE, NULL),
('CarDekho',        'Automotive',    'SMB',         'India',    'Trial',      '2023-02-05', 'Ankit Mehta',   FALSE, NULL),
('ShareChat',       'Social Media',  'Mid-Market',  'India',    'Outbound',   '2023-03-01', 'Rahul Vyas',    FALSE, NULL),
('Ola',             'Mobility',      'Enterprise',  'India',    'Partnership','2023-04-10', 'Priya Sood',    FALSE, NULL),
('Paytm',           'FinTech',       'Enterprise',  'India',    'Inbound',    '2023-05-15', 'Rahul Vyas',    FALSE, NULL),
('Zepto',           'Quick Commerce','Mid-Market',  'India',    'Outbound',   '2023-06-01', 'Ankit Mehta',   FALSE, NULL),
('Shiprocket',      'Logistics',     'SMB',         'India',    'Trial',      '2023-07-20', 'Priya Sood',    FALSE, NULL),
('BrowserStack',    'Dev Tools',     'Mid-Market',  'India',    'Inbound',    '2023-08-10', 'Rahul Vyas',    FALSE, NULL);

INSERT INTO subscriptions (account_id, plan_id, start_date, end_date, mrr, arr, seats, discount_pct, status) VALUES
(1,  7, '2022-01-15', NULL,         49999, 599988, 50,  0,    'Active'),
(2,  5, '2022-02-10', NULL,         18999, 227988, 20,  5,    'Active'),
(3,  4, '2022-03-05', NULL,          7999,  95988, 15,  10,   'Active'),
(4,  3, '2022-04-20', NULL,          7999,  95988, 12,  0,    'Active'),
(5,  1, '2022-05-01', NULL,          2999,  35988,  5,  0,    'Active'),
(6,  8, '2022-06-10', NULL,         49999, 599988, 75,  15,   'Active'),
(7,  4, '2022-07-15', '2023-07-31',  7999,  95988, 10,  0,    'Churned'),
(8,  4, '2022-08-05', NULL,          7999,  95988, 18,  5,    'Active'),
(9,  2, '2022-09-20', '2023-06-30',  2999,  35988,  5,  0,    'Churned'),
(10, 1, '2022-10-10', '2023-04-30',  2999,  35988,  3,  0,    'Churned'),
(11, 7, '2022-11-01', NULL,         49999, 599988, 100, 10,   'Active'),
(12, 8, '2022-12-15', NULL,         49999, 599988, 60,  0,    'Active'),
(13, 3, '2023-01-10', NULL,          7999,  95988, 14,  0,    'Active'),
(14, 1, '2023-02-05', NULL,          2999,  35988,  4,  0,    'Active'),
(15, 4, '2023-03-01', NULL,          7999,  95988, 16,  5,    'Active'),
(16, 6, '2023-04-10', NULL,         18999, 227988, 30,  0,    'Active'),
(17, 7, '2023-05-15', NULL,         49999, 599988, 80,  5,    'Active'),
(18, 3, '2023-06-01', NULL,          7999,  95988, 10,  0,    'Active'),
(19, 1, '2023-07-20', NULL,          2999,  35988,  6,  0,    'Active'),
(20, 4, '2023-08-10', NULL,          7999,  95988, 12,  0,    'Active');

INSERT INTO revenue_transactions (account_id, txn_date, txn_type, amount, seats_delta) VALUES
(1,  '2022-01-15', 'New Biz',   49999,  50),
(2,  '2022-02-10', 'New Biz',   18999,  20),
(3,  '2022-03-05', 'New Biz',    7999,  15),
(4,  '2022-04-20', 'New Biz',    7999,  12),
(5,  '2022-05-01', 'New Biz',    2999,   5),
(6,  '2022-06-10', 'New Biz',   49999,  75),
(7,  '2022-07-15', 'New Biz',    7999,  10),
(8,  '2022-08-05', 'New Biz',    7999,  18),
(9,  '2022-09-20', 'New Biz',    2999,   5),
(10, '2022-10-10', 'New Biz',    2999,   3),
(11, '2022-11-01', 'New Biz',   49999, 100),
(12, '2022-12-15', 'New Biz',   49999,  60),
(1,  '2022-12-01', 'Expansion', 10000,  10),
(2,  '2023-01-01', 'Expansion',  5000,   5),
(13, '2023-01-10', 'New Biz',    7999,  14),
(14, '2023-02-05', 'New Biz',    2999,   4),
(15, '2023-03-01', 'New Biz',    7999,  16),
(6,  '2023-03-01', 'Expansion', 15000,  15),
(10, '2023-04-30', 'Churn',     -2999,  -3),
(16, '2023-04-10', 'New Biz',   18999,  30),
(17, '2023-05-15', 'New Biz',   49999,  80),
(9,  '2023-06-30', 'Churn',     -2999,  -5),
(18, '2023-06-01', 'New Biz',    7999,  10),
(7,  '2023-07-31', 'Churn',     -7999, -10),
(19, '2023-07-20', 'New Biz',    2999,   6),
(11, '2023-07-01', 'Expansion', 12000,  12),
(20, '2023-08-10', 'New Biz',    7999,  12),
(1,  '2023-08-01', 'Renewal',   59999,  60),
(4,  '2023-05-01', 'Contraction',-2000, -3),
(3,  '2023-06-01', 'Upgrade',    9001,   5);

INSERT INTO expense_ledger (expense_date, category, sub_category, amount, is_cogs) VALUES
('2023-01-31', 'Cost of Revenue', 'Cloud Infrastructure',  850000, TRUE),
('2023-01-31', 'Cost of Revenue', 'Customer Support',      280000, TRUE),
('2023-01-31', 'Sales',           'SDR Salaries',          620000, FALSE),
('2023-01-31', 'Sales',           'AE Salaries',           940000, FALSE),
('2023-01-31', 'Marketing',       'Digital Advertising',   480000, FALSE),
('2023-01-31', 'Marketing',       'Content & Events',      120000, FALSE),
('2023-01-31', 'R&D',             'Engineering Salaries', 1850000, FALSE),
('2023-01-31', 'G&A',             'HR & Finance',          220000, FALSE),
('2023-02-28', 'Cost of Revenue', 'Cloud Infrastructure',  880000, TRUE),
('2023-02-28', 'Cost of Revenue', 'Customer Support',      290000, TRUE),
('2023-02-28', 'Sales',           'SDR Salaries',          620000, FALSE),
('2023-02-28', 'Sales',           'AE Salaries',           960000, FALSE),
('2023-02-28', 'Marketing',       'Digital Advertising',   510000, FALSE),
('2023-02-28', 'R&D',             'Engineering Salaries', 1900000, FALSE),
('2023-02-28', 'G&A',             'HR & Finance',          230000, FALSE),
('2023-03-31', 'Cost of Revenue', 'Cloud Infrastructure',  920000, TRUE),
('2023-03-31', 'Cost of Revenue', 'Customer Support',      310000, TRUE),
('2023-03-31', 'Sales',           'SDR Salaries',          640000, FALSE),
('2023-03-31', 'Sales',           'AE Salaries',           980000, FALSE),
('2023-03-31', 'Marketing',       'Digital Advertising',   550000, FALSE),
('2023-03-31', 'R&D',             'Engineering Salaries', 1950000, FALSE),
('2023-03-31', 'G&A',             'HR & Finance',          240000, FALSE),
('2023-04-30', 'Cost of Revenue', 'Cloud Infrastructure',  950000, TRUE),
('2023-04-30', 'Sales',           'AE Salaries',          1000000, FALSE),
('2023-04-30', 'Marketing',       'Digital Advertising',   580000, FALSE),
('2023-04-30', 'R&D',             'Engineering Salaries', 2000000, FALSE),
('2023-05-31', 'Cost of Revenue', 'Cloud Infrastructure',  980000, TRUE),
('2023-05-31', 'Sales',           'SDR Salaries',          660000, FALSE),
('2023-05-31', 'Marketing',       'Digital Advertising',   600000, FALSE),
('2023-05-31', 'R&D',             'Engineering Salaries', 2050000, FALSE),
('2023-06-30', 'Cost of Revenue', 'Cloud Infrastructure', 1020000, TRUE),
('2023-06-30', 'Sales',           'AE Salaries',          1050000, FALSE),
('2023-06-30', 'Marketing',       'Digital Advertising',   620000, FALSE),
('2023-06-30', 'R&D',             'Engineering Salaries', 2100000, FALSE),
('2023-07-31', 'Cost of Revenue', 'Cloud Infrastructure', 1050000, TRUE),
('2023-07-31', 'Sales',           'SDR Salaries',          680000, FALSE),
('2023-07-31', 'Marketing',       'Digital Advertising',   640000, FALSE),
('2023-07-31', 'R&D',             'Engineering Salaries', 2150000, FALSE),
('2023-08-31', 'Cost of Revenue', 'Cloud Infrastructure', 1080000, TRUE),
('2023-08-31', 'Sales',           'AE Salaries',          1080000, FALSE),
('2023-08-31', 'Marketing',       'Digital Advertising',   660000, FALSE),
('2023-08-31', 'R&D',             'Engineering Salaries', 2200000, FALSE);
-- ============================================================
-- SAAS FINANCIAL PERFORMANCE & UNIT ECONOMICS
-- FILE 2: Business Analysis Queries
-- Author : Mohd Zaid Ahmad | Business Analyst
-- ============================================================

-- ─────────────────────────────────────────────
-- ANALYSIS 1: MRR WATERFALL ANALYSIS
-- Business Question: How is our MRR changing each month?
-- (New Biz + Expansion + Contraction + Churn = Net New MRR)
-- ─────────────────────────────────────────────

WITH monthly_movements AS (
    SELECT
        TO_CHAR(txn_date, 'YYYY-MM')                              AS month,
        SUM(amount) FILTER (WHERE txn_type = 'New Biz')           AS new_mrr,
        SUM(amount) FILTER (WHERE txn_type = 'Expansion')         AS expansion_mrr,
        SUM(amount) FILTER (WHERE txn_type = 'Renewal')           AS renewal_mrr,
        ABS(SUM(amount) FILTER (WHERE txn_type = 'Contraction'))  AS contraction_mrr,
        ABS(SUM(amount) FILTER (WHERE txn_type = 'Churn'))        AS churned_mrr
    FROM revenue_transactions
    GROUP BY TO_CHAR(txn_date, 'YYYY-MM')
)
SELECT
    month,
    COALESCE(new_mrr, 0)         AS new_biz_mrr,
    COALESCE(expansion_mrr, 0)   AS expansion_mrr,
    COALESCE(renewal_mrr, 0)     AS renewal_mrr,
    COALESCE(contraction_mrr, 0) AS contraction_mrr,
    COALESCE(churned_mrr, 0)     AS churned_mrr,
    COALESCE(new_mrr, 0) + COALESCE(expansion_mrr, 0)
    - COALESCE(contraction_mrr, 0) - COALESCE(churned_mrr, 0)
                                 AS net_new_mrr,
    SUM(
        COALESCE(new_mrr, 0) + COALESCE(expansion_mrr, 0)
        - COALESCE(contraction_mrr, 0) - COALESCE(churned_mrr, 0)
    ) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                                 AS cumulative_mrr
FROM monthly_movements
ORDER BY month;


-- ─────────────────────────────────────────────
-- ANALYSIS 2: ARR & ANNUAL GROWTH RATE
-- Business Question: What is our Annual Recurring Revenue trajectory?
-- ─────────────────────────────────────────────

WITH monthly_arr AS (
    SELECT
        TO_CHAR(s.start_date, 'YYYY-MM')           AS month,
        SUM(s.mrr * 12)                            AS total_arr,
        COUNT(DISTINCT s.account_id)               AS paying_accounts,
        ROUND(AVG(s.mrr), 0)                       AS avg_mrr_per_account
    FROM subscriptions s
    WHERE s.status = 'Active'
    GROUP BY TO_CHAR(s.start_date, 'YYYY-MM')
)
SELECT
    month,
    total_arr,
    paying_accounts,
    avg_mrr_per_account,
    LAG(total_arr, 1) OVER (ORDER BY month)        AS prev_month_arr,
    ROUND((total_arr - LAG(total_arr, 1) OVER (ORDER BY month)) * 100.0 /
          NULLIF(LAG(total_arr, 1) OVER (ORDER BY month), 0), 1) AS mom_growth_pct
FROM monthly_arr
ORDER BY month;


-- ─────────────────────────────────────────────
-- ANALYSIS 3: CHURN ANALYSIS
-- Business Question: What is our churn rate and which segment is churning most?
-- ─────────────────────────────────────────────

-- Churn rate by segment
SELECT
    a.company_size,
    a.industry,
    COUNT(*) FILTER (WHERE a.is_churned = FALSE)   AS active_accounts,
    COUNT(*) FILTER (WHERE a.is_churned = TRUE)    AS churned_accounts,
    COUNT(*)                                       AS total_accounts,
    ROUND(COUNT(*) FILTER (WHERE a.is_churned = TRUE) * 100.0 /
          COUNT(*), 1)                             AS churn_rate_pct,
    ROUND(AVG(s.mrr) FILTER (WHERE a.is_churned = TRUE), 0)  AS avg_mrr_churned
FROM accounts a
JOIN subscriptions s ON a.account_id = s.account_id
GROUP BY a.company_size, a.industry
ORDER BY churn_rate_pct DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 4: CUSTOMER LIFETIME VALUE (LTV)
-- Business Question: What is the LTV of each customer segment?
-- LTV = ARPU / Churn Rate (simplified)
-- ─────────────────────────────────────────────

WITH segment_metrics AS (
    SELECT
        a.company_size,
        a.acquisition_channel,
        COUNT(DISTINCT a.account_id)               AS total_accounts,
        ROUND(AVG(s.mrr), 0)                       AS avg_mrr,
        COUNT(DISTINCT a.account_id) FILTER (WHERE a.is_churned = TRUE) * 1.0 /
            NULLIF(COUNT(DISTINCT a.account_id), 0) AS monthly_churn_rate
    FROM accounts a
    JOIN subscriptions s ON a.account_id = s.account_id
    GROUP BY a.company_size, a.acquisition_channel
)
SELECT
    company_size,
    acquisition_channel,
    total_accounts,
    avg_mrr,
    ROUND(monthly_churn_rate * 100, 1)             AS churn_rate_pct,
    CASE
        WHEN monthly_churn_rate > 0
        THEN ROUND(avg_mrr / monthly_churn_rate, 0)
        ELSE avg_mrr * 36                           -- assume 36-month life if no churn
    END                                            AS estimated_ltv,
    avg_mrr * 12                                   AS annual_revenue_per_account
FROM segment_metrics
ORDER BY estimated_ltv DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 5: CAC BY ACQUISITION CHANNEL
-- Business Question: How much does it cost to acquire each customer?
-- CAC = Total Sales + Marketing Spend / New Customers Acquired
-- ─────────────────────────────────────────────

WITH sales_mktg_spend AS (
    SELECT
        TO_CHAR(expense_date, 'YYYY-MM')           AS month,
        SUM(amount) FILTER (WHERE category = 'Sales')    AS sales_spend,
        SUM(amount) FILTER (WHERE category = 'Marketing') AS mktg_spend,
        SUM(amount) FILTER (WHERE category IN ('Sales','Marketing')) AS total_sam_spend
    FROM expense_ledger
    GROUP BY TO_CHAR(expense_date, 'YYYY-MM')
),
new_customers AS (
    SELECT
        TO_CHAR(signup_date, 'YYYY-MM')            AS month,
        acquisition_channel,
        COUNT(*)                                   AS new_customers
    FROM accounts
    GROUP BY TO_CHAR(signup_date, 'YYYY-MM'), acquisition_channel
),
total_new AS (
    SELECT
        month,
        SUM(new_customers)                         AS total_new_custs
    FROM new_customers
    GROUP BY month
)
SELECT
    ss.month,
    COALESCE(tn.total_new_custs, 0)               AS new_customers,
    ss.sales_spend,
    ss.mktg_spend,
    ss.total_sam_spend,
    CASE
        WHEN COALESCE(tn.total_new_custs, 0) > 0
        THEN ROUND(ss.total_sam_spend / tn.total_new_custs, 0)
        ELSE NULL
    END                                           AS blended_cac
FROM sales_mktg_spend ss
LEFT JOIN total_new tn ON ss.month = tn.month
ORDER BY ss.month;


-- ─────────────────────────────────────────────
-- ANALYSIS 6: P&L SUMMARY (MONTHLY)
-- Business Question: What is our Gross Margin, Operating Income?
-- ─────────────────────────────────────────────

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(txn_date, 'YYYY-MM')              AS month,
        SUM(CASE WHEN txn_type != 'Churn' THEN amount ELSE 0 END) AS total_revenue
    FROM revenue_transactions
    GROUP BY TO_CHAR(txn_date, 'YYYY-MM')
),
monthly_expenses AS (
    SELECT
        TO_CHAR(expense_date, 'YYYY-MM')          AS month,
        SUM(amount) FILTER (WHERE is_cogs = TRUE)  AS cogs,
        SUM(amount) FILTER (WHERE category = 'Sales') AS sales_opex,
        SUM(amount) FILTER (WHERE category = 'Marketing') AS mktg_opex,
        SUM(amount) FILTER (WHERE category = 'R&D') AS rd_opex,
        SUM(amount) FILTER (WHERE category = 'G&A') AS ga_opex,
        SUM(amount) FILTER (WHERE is_cogs = FALSE)  AS total_opex
    FROM expense_ledger
    GROUP BY TO_CHAR(expense_date, 'YYYY-MM')
)
SELECT
    me.month,
    COALESCE(mr.total_revenue, 0)                 AS total_revenue,
    me.cogs,
    COALESCE(mr.total_revenue, 0) - me.cogs       AS gross_profit,
    ROUND((COALESCE(mr.total_revenue, 0) - me.cogs) * 100.0 /
          NULLIF(COALESCE(mr.total_revenue, 0), 0), 1) AS gross_margin_pct,
    me.sales_opex,
    me.mktg_opex,
    me.rd_opex,
    me.ga_opex,
    me.total_opex,
    COALESCE(mr.total_revenue, 0) - me.cogs - me.total_opex AS operating_income,
    ROUND((COALESCE(mr.total_revenue, 0) - me.cogs - me.total_opex) * 100.0 /
          NULLIF(COALESCE(mr.total_revenue, 0), 0), 1) AS operating_margin_pct
FROM monthly_expenses me
LEFT JOIN monthly_revenue mr ON me.month = mr.month
ORDER BY me.month;


-- ─────────────────────────────────────────────
-- ANALYSIS 7: LTV:CAC RATIO (UNIT ECONOMICS HEALTH)
-- Business Question: Is our unit economics sustainable?
-- Benchmark: LTV:CAC > 3x is healthy; > 5x is excellent
-- ─────────────────────────────────────────────

WITH ltv_data AS (
    SELECT
        a.company_size,
        ROUND(AVG(s.mrr), 0)                       AS avg_mrr,
        COUNT(DISTINCT a.account_id) FILTER (WHERE a.is_churned = TRUE) * 1.0 /
            NULLIF(COUNT(DISTINCT a.account_id), 0) AS monthly_churn_rate
    FROM accounts a
    JOIN subscriptions s ON a.account_id = s.account_id
    GROUP BY a.company_size
),
cac_data AS (
    SELECT
        ROUND(SUM(amount) / NULLIF(
            (SELECT COUNT(*) FROM accounts WHERE signup_date >= '2023-01-01'), 0), 0) AS avg_cac
    FROM expense_ledger
    WHERE category IN ('Sales','Marketing')
      AND expense_date >= '2023-01-01'
)
SELECT
    l.company_size,
    l.avg_mrr,
    ROUND(l.monthly_churn_rate * 100, 1)           AS monthly_churn_pct,
    CASE
        WHEN l.monthly_churn_rate > 0
        THEN ROUND(l.avg_mrr / l.monthly_churn_rate, 0)
        ELSE l.avg_mrr * 36
    END                                            AS ltv,
    c.avg_cac,
    CASE
        WHEN c.avg_cac > 0 THEN
            ROUND(CASE
                WHEN l.monthly_churn_rate > 0
                THEN l.avg_mrr / l.monthly_churn_rate
                ELSE l.avg_mrr * 36
            END / c.avg_cac, 2)
        ELSE NULL
    END                                            AS ltv_cac_ratio,
    CASE
        WHEN CASE WHEN l.monthly_churn_rate > 0
                  THEN l.avg_mrr / l.monthly_churn_rate
                  ELSE l.avg_mrr * 36 END / NULLIF(c.avg_cac, 0) >= 5
        THEN '✅ Excellent (>5x)'
        WHEN CASE WHEN l.monthly_churn_rate > 0
                  THEN l.avg_mrr / l.monthly_churn_rate
                  ELSE l.avg_mrr * 36 END / NULLIF(c.avg_cac, 0) >= 3
        THEN '🟡 Healthy (3–5x)'
        ELSE '🔴 Needs Attention (<3x)'
    END                                            AS unit_economics_status
FROM ltv_data l
CROSS JOIN cac_data c
ORDER BY ltv_cac_ratio DESC NULLS LAST;


-- ─────────────────────────────────────────────
-- ANALYSIS 8: REVENUE CONCENTRATION RISK (LOGO CONCENTRATION)
-- Business Question: Are we too dependent on a few accounts?
-- ─────────────────────────────────────────────

WITH account_revenue AS (
    SELECT
        a.account_id,
        a.company_name,
        a.company_size,
        a.industry,
        SUM(rt.amount) FILTER (WHERE rt.txn_type != 'Churn') AS total_revenue,
        s.mrr
    FROM accounts a
    JOIN revenue_transactions rt ON a.account_id = rt.account_id
    JOIN subscriptions s          ON a.account_id = s.account_id
    WHERE a.is_churned = FALSE
    GROUP BY a.account_id, a.company_name, a.company_size, a.industry, s.mrr
)
SELECT
    company_name,
    company_size,
    industry,
    mrr,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 1) AS revenue_share_pct,
    ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) * 100.0 /
          SUM(total_revenue) OVER (), 1)                          AS cumulative_pct,
    RANK() OVER (ORDER BY total_revenue DESC)                     AS revenue_rank
FROM account_revenue
ORDER BY revenue_rank;
