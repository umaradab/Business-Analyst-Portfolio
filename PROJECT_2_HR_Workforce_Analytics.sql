-- ============================================================
-- PROJECT: HR Workforce & Attrition Analytics
-- Author  : Mohd Zaid Ahmad | Business Analyst
-- Tools   : SQL (PostgreSQL-compatible syntax)
-- Context : People Analytics — similar to McKinsey / Goldman
--           Sachs internal workforce reporting
-- Purpose : Understand attrition drivers, DEI metrics,
--           salary equity, and headcount planning
-- ============================================================

-- ─────────────────────────────────────────────
-- SECTION 0: SCHEMA SETUP
-- ─────────────────────────────────────────────

DROP TABLE IF EXISTS performance_reviews CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    dept_id     SERIAL PRIMARY KEY,
    dept_name   VARCHAR(80),
    division    VARCHAR(80),
    location    VARCHAR(80),
    headcount_budget INT
);

CREATE TABLE employees (
    emp_id              SERIAL PRIMARY KEY,
    emp_name            VARCHAR(100),
    dept_id             INT REFERENCES departments(dept_id),
    job_role            VARCHAR(80),
    job_level           VARCHAR(20),    -- 'Junior','Mid','Senior','Lead','Manager','Director'
    gender              VARCHAR(10),
    age                 INT,
    education           VARCHAR(40),    -- 'High School','Graduate','Post-Graduate','PhD'
    years_at_company    INT,
    years_in_role       INT,
    monthly_salary      NUMERIC(10,2),
    business_travel     VARCHAR(20),    -- 'None','Rarely','Frequently'
    overtime            BOOLEAN,
    num_companies_worked INT,
    hire_date           DATE,
    exit_date           DATE,           -- NULL if still active
    attrition           BOOLEAN DEFAULT FALSE,
    attrition_reason    VARCHAR(80)     -- NULL if active
);

CREATE TABLE performance_reviews (
    review_id           SERIAL PRIMARY KEY,
    emp_id              INT REFERENCES employees(emp_id),
    review_year         INT,
    performance_rating  INT CHECK (performance_rating BETWEEN 1 AND 5),
    manager_rating      INT CHECK (manager_rating BETWEEN 1 AND 5),
    self_rating         INT CHECK (self_rating BETWEEN 1 AND 5),
    work_life_balance   INT CHECK (work_life_balance BETWEEN 1 AND 4),
    job_satisfaction    INT CHECK (job_satisfaction BETWEEN 1 AND 4),
    env_satisfaction    INT CHECK (env_satisfaction BETWEEN 1 AND 4),
    training_sessions   INT
);

-- ─────────────────────────────────────────────
-- SEED DATA
-- ─────────────────────────────────────────────

INSERT INTO departments (dept_name, division, location, headcount_budget) VALUES
('Engineering',         'Technology',   'Bangalore', 150),
('Product Management',  'Technology',   'Gurgaon',    40),
('Sales',               'Revenue',      'Mumbai',     80),
('Marketing',           'Revenue',      'Delhi',      35),
('Human Resources',     'Operations',   'Hyderabad',  25),
('Finance',             'Operations',   'Mumbai',     30),
('Customer Success',    'Revenue',      'Pune',       60),
('Data & Analytics',    'Technology',   'Bangalore',  45);

INSERT INTO employees (emp_name, dept_id, job_role, job_level, gender, age, education,
    years_at_company, years_in_role, monthly_salary, business_travel, overtime,
    num_companies_worked, hire_date, exit_date, attrition, attrition_reason) VALUES
('Aryan Mehta',       1, 'Software Engineer',       'Mid',      'Male',   28, 'Graduate',       3, 2, 85000,  'Rarely',     FALSE, 2, '2021-03-15', NULL,         FALSE, NULL),
('Simran Kaur',       1, 'Senior Engineer',         'Senior',   'Female', 32, 'Post-Graduate',  6, 3, 130000, 'None',       FALSE, 1, '2018-06-01', NULL,         FALSE, NULL),
('Dev Sharma',        2, 'Product Manager',         'Mid',      'Male',   30, 'Post-Graduate',  4, 4, 115000, 'Frequently', TRUE,  3, '2020-01-10', NULL,         FALSE, NULL),
('Prachi Jain',       3, 'Sales Executive',         'Junior',   'Female', 25, 'Graduate',       1, 1, 42000,  'Rarely',     TRUE,  1, '2023-02-01', '2023-09-30', TRUE,  'Better Opportunity'),
('Nikhil Rao',        4, 'Marketing Analyst',       'Mid',      'Male',   27, 'Graduate',       2, 2, 62000,  'None',       FALSE, 2, '2022-04-15', NULL,         FALSE, NULL),
('Sakshi Gupta',      5, 'HR Business Partner',     'Senior',   'Female', 35, 'Post-Graduate',  8, 4, 98000,  'Rarely',     FALSE, 2, '2016-07-01', NULL,         FALSE, NULL),
('Rajan Patel',       6, 'Finance Analyst',         'Mid',      'Male',   29, 'Post-Graduate',  3, 3, 75000,  'None',       FALSE, 2, '2021-09-01', NULL,         FALSE, NULL),
('Ananya Singh',      7, 'Customer Success Mgr',    'Senior',   'Female', 31, 'Graduate',       5, 3, 88000,  'Rarely',     TRUE,  3, '2019-11-01', NULL,         FALSE, NULL),
('Varun Kumar',       8, 'Data Analyst',            'Mid',      'Male',   26, 'Post-Graduate',  2, 2, 70000,  'None',       FALSE, 1, '2022-06-01', NULL,         FALSE, NULL),
('Deepika Nair',      1, 'Lead Engineer',           'Lead',     'Female', 36, 'Post-Graduate',  9, 4, 165000, 'None',       FALSE, 1, '2015-03-01', NULL,         FALSE, NULL),
('Karan Bhatia',      3, 'Senior Sales Exec',       'Senior',   'Male',   33, 'Graduate',       7, 5, 105000, 'Frequently', TRUE,  4, '2017-08-01', '2023-05-31', TRUE,  'Work-Life Balance'),
('Meghna Verma',      4, 'Brand Manager',           'Senior',   'Female', 34, 'Post-Graduate',  6, 4, 112000, 'Rarely',     FALSE, 2, '2018-02-01', NULL,         FALSE, NULL),
('Abhishek Roy',      1, 'Junior Engineer',         'Junior',   'Male',   23, 'Graduate',       1, 1, 55000,  'None',       FALSE, 1, '2023-07-01', NULL,         FALSE, NULL),
('Tanisha Malhotra',  2, 'Associate PM',            'Junior',   'Female', 24, 'Graduate',       1, 1, 65000,  'None',       TRUE,  1, '2023-04-01', NULL,         FALSE, NULL),
('Vikas Tiwari',      5, 'HR Analyst',              'Junior',   'Male',   25, 'Graduate',       2, 2, 48000,  'None',       FALSE, 2, '2022-01-10', '2023-03-31', TRUE,  'Relocation'),
('Pooja Srivastava',  6, 'Senior Finance Analyst',  'Senior',   'Female', 38, 'Post-Graduate', 11, 6, 148000, 'Rarely',     FALSE, 1, '2013-05-01', NULL,         FALSE, NULL),
('Sameer Qureshi',    7, 'CS Specialist',           'Mid',      'Male',   28, 'Graduate',       3, 3, 58000,  'Rarely',     TRUE,  3, '2021-01-15', '2023-08-31', TRUE,  'Low Salary'),
('Nandita Chandra',   8, 'Senior Data Analyst',     'Senior',   'Female', 30, 'Post-Graduate',  4, 3, 95000,  'None',       FALSE, 2, '2020-08-01', NULL,         FALSE, NULL),
('Rohit Mishra',      1, 'Engineering Manager',     'Manager',  'Male',   40, 'Post-Graduate', 12, 5, 210000, 'Frequently', TRUE,  3, '2012-01-01', NULL,         FALSE, NULL),
('Kaveri Krishnan',   4, 'Marketing Director',      'Director', 'Female', 44, 'PhD',           15, 8, 285000, 'Frequently', FALSE, 2, '2009-06-01', NULL,         FALSE, NULL),
('Arpit Dubey',       3, 'Sales Manager',           'Manager',  'Male',   37, 'Post-Graduate',  8, 4, 165000, 'Frequently', TRUE,  5, '2016-03-01', '2023-11-30', TRUE,  'Career Growth'),
('Swati Bajaj',       2, 'Senior PM',               'Senior',   'Female', 35, 'Post-Graduate',  6, 4, 155000, 'Rarely',     FALSE, 2, '2018-09-01', NULL,         FALSE, NULL),
('Harshit Agarwal',   8, 'Data Science Lead',       'Lead',     'Male',   32, 'PhD',            5, 3, 178000, 'None',       FALSE, 2, '2019-07-01', NULL,         FALSE, NULL),
('Ritika Pandey',     5, 'HR Manager',              'Manager',  'Female', 42, 'Post-Graduate', 14, 7, 195000, 'Rarely',     FALSE, 1, '2010-04-01', NULL,         FALSE, NULL),
('Aditya Bansal',     6, 'Finance Manager',         'Manager',  'Male',   39, 'Post-Graduate', 10, 5, 220000, 'None',       FALSE, 2, '2014-02-01', NULL,         FALSE, NULL);

INSERT INTO performance_reviews (emp_id, review_year, performance_rating, manager_rating, self_rating,
    work_life_balance, job_satisfaction, env_satisfaction, training_sessions) VALUES
(1,  2023, 4, 4, 4, 3, 4, 3, 4),
(2,  2023, 5, 5, 4, 4, 5, 4, 3),
(3,  2023, 4, 3, 4, 2, 3, 3, 5),
(4,  2023, 3, 3, 3, 2, 2, 2, 2),
(5,  2023, 4, 4, 4, 3, 4, 4, 4),
(6,  2023, 5, 5, 5, 4, 5, 5, 3),
(7,  2023, 4, 4, 4, 3, 4, 4, 4),
(8,  2023, 4, 4, 4, 3, 4, 3, 5),
(9,  2023, 4, 4, 4, 4, 4, 4, 6),
(10, 2023, 5, 5, 5, 4, 5, 5, 2),
(11, 2023, 3, 3, 3, 1, 2, 2, 3),
(12, 2023, 5, 4, 5, 4, 4, 4, 3),
(13, 2023, 3, 3, 3, 3, 3, 3, 4),
(14, 2023, 4, 4, 4, 3, 4, 4, 5),
(15, 2023, 3, 2, 3, 2, 2, 2, 2),
(16, 2023, 5, 5, 5, 4, 5, 5, 2),
(17, 2023, 3, 3, 3, 2, 2, 2, 3),
(18, 2023, 5, 5, 5, 4, 5, 5, 4),
(19, 2023, 5, 5, 4, 3, 4, 4, 3),
(20, 2023, 5, 5, 5, 3, 4, 4, 2),
(21, 2023, 3, 3, 3, 2, 2, 2, 4),
(22, 2023, 5, 5, 5, 4, 5, 4, 3),
(23, 2023, 5, 5, 5, 4, 5, 5, 5),
(24, 2023, 5, 5, 5, 4, 5, 5, 2),
(25, 2023, 5, 4, 5, 3, 4, 4, 2);
-- ============================================================
-- HR WORKFORCE & ATTRITION ANALYTICS
-- FILE 2: Business Analysis Queries
-- Author : Mohd Zaid Ahmad | Business Analyst
-- ============================================================

-- ─────────────────────────────────────────────
-- ANALYSIS 1: HEADCOUNT OVERVIEW BY DEPARTMENT
-- Business Question: What is the current headcount distribution?
-- ─────────────────────────────────────────────

SELECT
    d.dept_name,
    d.division,
    d.location,
    d.headcount_budget,
    COUNT(e.emp_id) FILTER (WHERE e.attrition = FALSE)            AS active_headcount,
    d.headcount_budget - COUNT(e.emp_id) FILTER (WHERE e.attrition = FALSE) AS open_positions,
    ROUND(COUNT(e.emp_id) FILTER (WHERE e.attrition = FALSE) * 100.0 /
          d.headcount_budget, 1)                                  AS fill_rate_pct,
    ROUND(AVG(e.monthly_salary) FILTER (WHERE e.attrition = FALSE), 0) AS avg_monthly_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name, d.division, d.location, d.headcount_budget
ORDER BY active_headcount DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 2: ATTRITION RATE BY DEPARTMENT & JOB LEVEL
-- Business Question: Where and at what level are we losing talent?
-- ─────────────────────────────────────────────

SELECT
    d.dept_name,
    e.job_level,
    COUNT(*) FILTER (WHERE e.attrition = TRUE)                    AS attrition_count,
    COUNT(*)                                                      AS total_employees,
    ROUND(COUNT(*) FILTER (WHERE e.attrition = TRUE) * 100.0 /
          COUNT(*), 1)                                            AS attrition_rate_pct,
    AVG(e.years_at_company) FILTER (WHERE e.attrition = TRUE)     AS avg_tenure_lost_yrs
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name, e.job_level
HAVING COUNT(*) > 1
ORDER BY attrition_rate_pct DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 3: ATTRITION REASON ANALYSIS
-- Business Question: Why are employees leaving?
-- ─────────────────────────────────────────────

SELECT
    attrition_reason,
    COUNT(*)                                                      AS employees_left,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)           AS pct_of_attrition,
    ROUND(AVG(monthly_salary), 0)                                 AS avg_salary_of_departed,
    ROUND(AVG(years_at_company), 1)                               AS avg_tenure_yrs,
    ROUND(AVG(age), 1)                                            AS avg_age
FROM employees
WHERE attrition = TRUE
GROUP BY attrition_reason
ORDER BY employees_left DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 4: SALARY EQUITY ANALYSIS (GENDER PAY GAP)
-- Business Question: Is there a pay disparity between genders?
-- ─────────────────────────────────────────────

SELECT
    d.dept_name,
    e.job_level,
    e.gender,
    COUNT(*)                                                      AS headcount,
    ROUND(AVG(e.monthly_salary), 0)                               AS avg_salary,
    ROUND(MIN(e.monthly_salary), 0)                               AS min_salary,
    ROUND(MAX(e.monthly_salary), 0)                               AS max_salary,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP
          (ORDER BY e.monthly_salary), 0)                         AS median_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.attrition = FALSE
GROUP BY d.dept_name, e.job_level, e.gender
ORDER BY d.dept_name, e.job_level, e.gender;


-- ─────────────────────────────────────────────
-- ANALYSIS 5: HIGH PERFORMER IDENTIFICATION
-- Business Question: Who are our top performers and are we retaining them?
-- ─────────────────────────────────────────────

WITH ranked_employees AS (
    SELECT
        e.emp_id,
        e.emp_name,
        d.dept_name,
        e.job_role,
        e.job_level,
        e.monthly_salary,
        e.years_at_company,
        e.attrition,
        pr.performance_rating,
        pr.job_satisfaction,
        pr.work_life_balance,
        RANK() OVER (PARTITION BY e.dept_id
                     ORDER BY pr.performance_rating DESC,
                              pr.job_satisfaction DESC)           AS dept_rank
    FROM employees e
    JOIN departments d       ON e.dept_id  = d.dept_id
    JOIN performance_reviews pr ON e.emp_id = pr.emp_id
)
SELECT
    emp_name,
    dept_name,
    job_role,
    job_level,
    monthly_salary,
    years_at_company,
    performance_rating,
    job_satisfaction,
    work_life_balance,
    dept_rank,
    attrition,
    CASE
        WHEN attrition = TRUE  AND performance_rating >= 4 THEN '⚠️ HIGH VALUE LOSS'
        WHEN attrition = FALSE AND performance_rating >= 4 THEN '✅ RETAIN & GROW'
        WHEN attrition = FALSE AND performance_rating <= 2 THEN '🔵 NEEDS DEVELOPMENT'
        ELSE 'MONITOR'
    END                                                           AS talent_status
FROM ranked_employees
WHERE dept_rank <= 2
ORDER BY dept_name, dept_rank;


-- ─────────────────────────────────────────────
-- ANALYSIS 6: OVERTIME IMPACT ON ATTRITION
-- Business Question: Does overtime correlate with higher attrition?
-- ─────────────────────────────────────────────

SELECT
    overtime,
    business_travel,
    COUNT(*)                                                      AS total_employees,
    COUNT(*) FILTER (WHERE attrition = TRUE)                      AS left_company,
    ROUND(COUNT(*) FILTER (WHERE attrition = TRUE) * 100.0 /
          COUNT(*), 1)                                            AS attrition_rate_pct,
    ROUND(AVG(monthly_salary), 0)                                 AS avg_salary,
    ROUND(AVG(age), 1)                                            AS avg_age
FROM employees
GROUP BY overtime, business_travel
ORDER BY attrition_rate_pct DESC;


-- ─────────────────────────────────────────────
-- ANALYSIS 7: TRAINING EFFECTIVENESS
-- Business Question: Does more training improve performance ratings?
-- ─────────────────────────────────────────────

SELECT
    pr.training_sessions,
    COUNT(*)                                                      AS employee_count,
    ROUND(AVG(pr.performance_rating), 2)                          AS avg_performance,
    ROUND(AVG(pr.job_satisfaction), 2)                            AS avg_job_satisfaction,
    ROUND(AVG(pr.work_life_balance), 2)                           AS avg_wlb_score,
    COUNT(*) FILTER (WHERE e.attrition = TRUE)                    AS attrition_count,
    ROUND(COUNT(*) FILTER (WHERE e.attrition = TRUE) * 100.0 /
          COUNT(*), 1)                                            AS attrition_rate_pct
FROM performance_reviews pr
JOIN employees e ON pr.emp_id = e.emp_id
GROUP BY pr.training_sessions
ORDER BY pr.training_sessions;


-- ─────────────────────────────────────────────
-- ANALYSIS 8: SALARY BAND ANALYSIS BY LEVEL
-- Business Question: Are our compensation bands competitive?
-- ─────────────────────────────────────────────

SELECT
    job_level,
    COUNT(*)                                                              AS headcount,
    ROUND(MIN(monthly_salary), 0)                                         AS salary_min,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY monthly_salary), 0) AS salary_p25,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY monthly_salary), 0) AS salary_median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monthly_salary), 0) AS salary_p75,
    ROUND(MAX(monthly_salary), 0)                                         AS salary_max,
    ROUND(AVG(monthly_salary), 0)                                         AS salary_avg,
    ROUND(STDDEV(monthly_salary), 0)                                      AS salary_stddev
FROM employees
WHERE attrition = FALSE
GROUP BY job_level
ORDER BY salary_avg;
