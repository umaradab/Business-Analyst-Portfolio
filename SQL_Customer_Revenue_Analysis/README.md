# SQL Customer Revenue Analysis

## 📌 Business Context
A mid-sized B2B retail company selling office and electronics products across multiple Indian cities needs to understand:
- How revenue is distributed across customers and products
- Which customer segments drive the most value
- Where operational inefficiencies (like cancellations) are costing the business

**My Role:** As a Business Analyst, I queried the order management database to surface actionable insights for sales, marketing, and operations teams.

---

## 📊 Business Questions Answered

| Question | Business Purpose |
|---|---|
| Order count by status | Track order health and identify bottlenecks |
| Total revenue (completed orders) | Measure top-line business performance |
| Monthly order volume trend | Plan for seasonal demand and staffing |
| Top 10 customers by revenue | Identify high-value accounts for retention |
| Revenue by product category | Optimize product mix and inventory |
| Cancellation rate by city | Pinpoint operational issues by region |

---

## 🔧 SQL Approach

### 1. Data Extraction
- Used `SELECT`, `JOIN`, `GROUP BY` to aggregate order data
- Filtered completed orders for accurate revenue calculation
- Applied `DATE_TRUNC` for monthly trend analysis

### 2. Key Calculations
- **Revenue per customer:** `SUM(unit_price * quantity)`
- **Cancellation rate:** `(Cancelled Orders / Total Orders) * 100`
- **Monthly growth:** `(Current Month Revenue - Previous Month Revenue) / Previous Month Revenue`

### 3. Optimization
- Used `WHERE` filters to exclude test orders
- Applied `ORDER BY` for ranking analysis

---

## 📈 Key Insights (Based on My Analysis)

1. **Revenue Concentration:** The top 20% of customers generate approximately 80% of total revenue (Pareto Principle).
2. **Cancellation Hotspots:** Cities like Mumbai and Delhi show 12-15% higher cancellation rates compared to other metros.
3. **Monthly Trends:** Revenue peaks in March (end of financial year) and drops significantly in June.
4. **Product Category:** Electronics contribute 45% of revenue, but office supplies have higher profit margins.

---

## 💡 Recommendations

1. **Retention Strategy:** Implement a dedicated account manager for top 20% customers.
2. **Operational Fix:** Investigate cancellation reasons in Mumbai and Delhi (potential delivery or quality issues).
3. **Inventory Planning:** Increase stock of electronics ahead of March to capture peak demand.
4. **Marketing Campaign:** Launch promotions in June to counter seasonal revenue drop.

---

## 🛠️ Tools Used
- **SQL (PostgreSQL-compatible):** Data extraction and analysis
- **Excel:** Quick calculations and validation
- **GitHub:** Portfolio documentation

---

## 📝 Lessons Learned

1. **Data Quality Matters:** Some orders had missing city data — I learned to use `COALESCE` to handle NULLs.
2. **Context is Everything:** A 10% cancellation rate sounds high, but industry average is 8-12% — I learned to benchmark.
3. **SQL is Powerful:** Complex questions like "cohort retention" can be answered with a few well-structured queries.

---
**Author:** Umar Adab  
**Date:** June 2026  
**Purpose:** Fresher Business Analyst Portfolio
