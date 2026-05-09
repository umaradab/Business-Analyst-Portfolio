# 🗄️ SQL Projects — Business Analyst Portfolio

> **Mohd Zaid Ahmad** | Business Analyst | Kanpur → Delhi NCR  
> 📧 GitHub: [ZaidAhmad122](https://github.com/ZaidAhmad122) · Tools: PostgreSQL, Power BI, Excel, Python

---

## 📦 Projects Overview

This repository contains **3 end-to-end SQL projects** covering the most in-demand domains for Business Analysts — E-Commerce, HR Analytics, and SaaS Finance. Each project includes a complete relational schema, realistic seed data, and deeply commented business analysis queries.

---

| # | Project | Domain | SQL Level | Key Concepts |
|---|---------|--------|-----------|--------------|
| 1 | [🛒 E-Commerce Funnel & Revenue Analysis](#1-e-commerce-funnel--revenue-analysis) | Retail / D2C | Intermediate–Advanced | RFM, Cohort Retention, Funnel CVR |
| 2 | [👥 HR Workforce & Attrition Analytics](#2-hr-workforce--attrition-analytics) | People Analytics | Intermediate–Advanced | Attrition, Pay Equity, Talent Matrix |
| 3 | [📊 SaaS Financial Performance Dashboard](#3-saas-financial-performance-dashboard) | FP&A / SaaS Finance | Advanced | MRR Waterfall, LTV:CAC, P&L in SQL |

---

## 1. 🛒 E-Commerce Funnel & Revenue Analysis

**Context:** Analyst at a D2C/e-commerce company (Myntra, Nykaa, Amazon India)

| Analysis | Business Question |
|---|---|
| Monthly Revenue Trend | How is revenue growing MoM? |
| Funnel by Channel | Which marketing channel converts best? |
| Product Profitability | Which products drive the most gross margin? |
| RFM Segmentation | Who are our Champions and At-Risk customers? |
| Cohort Retention | Do customers return after their first purchase? |
| Return & Cancellation | Where is revenue leaking through returns? |
| Device Performance | Mobile vs Desktop — where should we invest? |

📁 [`1_ecommerce_funnel_analysis/`](./1_ecommerce_funnel_analysis/)

---

## 2. 👥 HR Workforce & Attrition Analytics

**Context:** People Analytics / HR Business Partner at a tech company or consulting firm

| Analysis | Business Question |
|---|---|
| Headcount Overview | Headcount vs. budget by department |
| Attrition by Level | Where and at what level are we losing talent? |
| Attrition Reasons | Why are employees leaving? |
| Gender Pay Gap | Is there salary inequity between genders? |
| High Performer ID | Who are top performers — and are they at risk? |
| Overtime & Attrition | Does overtime correlate with higher churn? |
| Training Effectiveness | Does training improve performance and reduce attrition? |
| Salary Band Analysis | Are compensation bands competitive and fair? |

📁 [`2_hr_workforce_analytics/`](./2_hr_workforce_analytics/)

---

## 3. 📊 SaaS Financial Performance Dashboard

**Context:** FP&A Analyst at a B2B SaaS company (Oracle, Freshworks, or a unicorn startup)

| Analysis | Business Question |
|---|---|
| MRR Waterfall | How is MRR moving: New Biz, Expansion, Churn? |
| ARR Trajectory | What is our ARR growth trend? |
| Churn Analysis | Which segments churn most? |
| Customer LTV | What is the lifetime value by segment? |
| CAC by Channel | How much does each customer cost to acquire? |
| P&L Summary | What is our Gross Margin and Operating Income? |
| LTV:CAC Ratio | Is our unit economics healthy (>3x)? |
| Revenue Concentration | Are we too dependent on a few accounts? |

📁 [`3_financial_performance_dashboard/`](./3_financial_performance_dashboard/)

---

## 🛠 How to Run Any Project

```sql
-- Step 1: Run schema + data setup
\i queries/01_schema_and_data.sql

-- Step 2: Run analysis queries
\i queries/02_analysis_queries.sql
```

Compatible with: **PostgreSQL 12+**, DBeaver, pgAdmin, Supabase, Neon, ElephantSQL

---

## 🧠 SQL Concepts Demonstrated

| Concept | Projects |
|---|---|
| CTEs (WITH clauses) | All 3 |
| Window Functions (RANK, NTILE, LAG, SUM OVER) | All 3 |
| Conditional Aggregation (FILTER WHERE) | All 3 |
| PERCENTILE_CONT (P25/P50/P75) | Project 2 |
| RFM Customer Segmentation | Project 1 |
| Cohort Retention Analysis | Project 1 |
| Salary / Pay Equity Analysis | Project 2 |
| MRR Waterfall | Project 3 |
| LTV:CAC Unit Economics | Project 3 |
| P&L Construction | Project 3 |
| CASE WHEN Labelling | All 3 |
| Multi-table JOINs | All 3 |
| NULLIF (safe division) | All 3 |

---

## 📬 Connect

**Mohd Zaid Ahmad**  
Business Analyst | BBA Final Year, AIHE Kanpur (CSJMU)  
🔗 [LinkedIn](https://linkedin.com/in/mohdzaidahmad) · 📺 [@zaid_decode](https://instagram.com/zaid_decode)
