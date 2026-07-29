# E-Commerce Sales & Customer Analytics — End-to-End Portfolio Project

An end-to-end analytics project on 805,549 UK retail transactions (2009-2011) to segment customers, analyze retention, and validate findings statistically.

### Business Questions Answered
1. Who are our most valuable customers?
2. Do customer segments really spend differently or is it random?
3. Is there real seasonality in revenue?
4. What is the estimated Lifetime Value (CLV) of a customer?

### Key Results (Statistically Validated in R)
- **Median Estimated CLV: £1,334.67** (3-year lifespan assumption)
- **RFM Segmentation: 5,878 customers** classified as Champions, Loyal Customers, At Risk, Lost, etc.
- **ANOVA Monetary by Segment: p = 3.17e-68** -> Highly significant. Champions vs Lost segments have genuinely different spending behavior.
- **ANOVA Revenue by Month: p = 1.42e-08** -> Highly significant seasonality confirmed, not just noise.
- **Data Pipeline Outputs:** `transactions_clean.csv`, `rfm_segments.csv`, `cohort_table.csv`, `clv_estimates.csv`

### Tech Stack
- **Python:** Pandas, Matplotlib, Seaborn (RFM, Cohort Analysis)
- **R:** aov(), Tukey HSD, CLV Heuristic
- **Power BI:** 3-page executive dashboard (RFM, Retention, Revenue Trends)
- **Git / GitHub**

### Project Structure
