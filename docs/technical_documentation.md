# Technical Documentation — E-commerce Sales & Customer Analytics
**Author:** Antonio Fuentes Moreno | BI Consulting Engagement
**Stack:** Python (pandas) | R (ggplot2, stats) | Power BI (DAX) | Git
**Dataset:** Online Retail II — 1.07M transactions | 5,878 customers | Dec 2009 - Dec 2011
**Last Updated:** Aug 2026

---

### 1. Executive Summary
This is not a dashboard project. It is a full BI consulting delivery structured in 3 questions:
1.  **Where is revenue concentrated?** (Sales Diagnostics)
2.  **Which customers are worth protecting?** (RFM Segmentation)
3.  **Where does retention break down?** (Cohort Retention Audit)

Every visual in Power BI is backed by a statistical test in R. No insight is presented without a p-value.

**Headline Result:** 22% of customers (Champions) drive 17x purchase frequency vs Lost. 81% churn in M1. The business doesn't have an acquisition problem, it has a Day 1-30 activation problem.

### 2. Architecture & Data Flow

```
raw/online_retail_ii.xlsx (1.07M rows)
   ↓ [01_data_preparation.ipynb]
processed/transactions_clean.csv (805,549 rows) → Rule: Remove cancellations, StockCode = AMAZ, zero price, no CustomerID
   ↓
   ├─→ rfm_table.csv → [02_rfm_segmentation.ipynb] → 6 actionable segments
   ├─→ monthly_revenue.csv → [Sales Diagnostics]
   └─→ cohort_table.csv → [03_cohort_analysis.ipynb] → 25 cohorts x 25 months
           ↓
        [04_05 - R] → ANOVA validation + heatmap + decay curve (19% M1)
           ↓
        [Power BI] → 3-page executive report
```

### 3. Data Cleaning Rules (Reproducibility Critical)
Applied in `01_data_preparation.ipynb`:

- **Filter 1:** `Quantity <= 0` OR `InvoiceNo LIKE 'C%'` → Cancellation → Removed (18% of rows)
- **Filter 2:** `StockCode = AMAZON, DOT, POST, etc` → Non-product → Removed
- **Filter 3:** `CustomerID IS NULL` → Unattributable → Removed for RFM/Cohort, kept for total revenue calc
- **Filter 4:** `Price <= 0` → Removed
- **Creation:** `Revenue = Quantity * Price`, `InvoiceDate parsed to UTC`, `Country cleaned`

**Result:** 806K clean rows (75% retention of raw). File: `data/processed/transactions_clean.csv`

### 4. RFM Segmentation Logic
File: `02_rfm_segmentation.ipynb`

- **Recency:** Days since last purchase (Reference date = max(InvoiceDate) + 1 day = 2011-12-10)
- **Frequency:** Count distinct InvoiceNo
- **Monetary:** Sum(Revenue)
- **Scoring:** Quintile `qcut` 1-5 (5 is best). R is inverted (smaller days = 5).
- **Segment Mapping (Consulting Standard):**

| Segment | RFM Pattern | Business Action |
|---|---|---|
| Champions | R=5, F=4-5, M=4-5 | VIP program, early access |
| Loyal | F=3-5 | Cross-sell |
| Potential Loyalist | R=4-5, F=1-2 | Onboarding nurture Day 1-30 |
| At Risk | R=1-2, F=3-5 | Win-back campaign |
| Can't Lose Them | R=1, M=4-5 | Personal outreach |
| Lost | R=1-2, F=1-2 | Re-activation test |

**Statistical Validation:** `aov(Monetary ~ Segment)` p = 3.18e-68. `TukeyHSD` shows Champions vs Lost delta £3,800 median (p<0.001). See `r/04_statistical_validation.R`.

### 5. Cohort Retention Analysis
File: `03_cohort_analysis.ipynb` + `r/04_05...`

- **Cohort Definition:** First purchase month = CohortMonth. Tracked 25 cohorts (Dec 09 - Dec 11).
- **Metric:** `Retention[M] = Customers active in M / CohortSize`. Churn = 1 - Retention.
- **Key KPI (Real, not example):**
  - Avg M1 Retention = **19%** (81% Churn)
  - Avg M3 Retention = **13%**
  - Best Cohort = **Dec 09 (32%)** - small sample outlier, flagged
  - Worst = Jun 10 (8%)

**Why 19% is not a failure:** UK e-commerce benchmark for non-subscription retail is 15-25% M1. This business is average, but cliff is steep (100% -> 19% in 30 days). Lever is activation, not loyalty.

R Visuals:
- `cohort_retention_heatmap_pro.png` — ggplot2 tile with % labels
- `retention_vs_churn_19pro.png` — decay curve with 19%/81% annotations (fixed annotation to avoid 19% looking like 49%)

### 6. Power BI DAX Measures (Production Grade)

```DAX
Total Revenue = SUM(transactions_clean[Revenue])

Active Customers = DISTINCTCOUNT(transactions_clean[CustomerID])

Avg Revenue per Customer = DIVIDE([Total Revenue], [Active Customers])

Month-1 Retention = 
VAR CohortSize = CALCULATE(DISTINCTCOUNT(transactions_clean[CustomerID]), ALLEXCEPT(cohort_table, cohort_table[CohortMonth]))
VAR RetainedM1 = CALCULATE(DISTINCTCOUNT(transactions_clean[CustomerID]), cohort_table[CohortIndex]=1)
RETURN DIVIDE(RetainedM1, CohortSize)

Churn M1 = 1 - [Month-1 Retention]

CLV Heuristic (3yr) = 
// Simple diagnostic: Avg Revenue * Purchase Frequency * Gross Margin * Lifespan (3 years)
// Not probabilistic, flagged as limitation
[Avg Revenue per Customer] * 12 * 3 * 0.1
```

**Data Modeling:** Star schema - Fact = transactions_clean, Dimensions = rfm_table, cohort_table, date_table. No bidirectional filters.

### 7. Statistical Validation Results
File: `r/04_statistical_validation.R`

| Test | Hypothesis | Result | Interpretation |
|---|---|---|---|
| ANOVA Monetary by Segment | H0: All segments equal spend | F=78.4, p=3.18e-68 | REJECT. Segments are materially different |
| TukeyHSD Champions-Lost | Delta spend | £3,812, p<0.001 | Champions worth protecting |
| ANOVA Revenue by Month | H0: No seasonality | p=1.43e-08 | REJECT. Nov peak is significant, not noise |
| Shapiro + Levene | Normality/Homoscedasticity | Violated, but n=5878 → CLT applies, ANOVA robust | Documented |

### 8. Reproducibility
```bash
git clone https://github.com/FuentesAntro/ecommerce-sales-customer-analytics.git
pip install -r requirements.txt
# Place Online Retail II xlsx in data/raw/
jupyter notebook notebooks/01_data_preparation.ipynb
jupyter notebook notebooks/02_rfm_segmentation.ipynb
jupyter notebook notebooks/03_cohort_analysis.ipynb
Rscript r/04_statistical_validation.R
Rscript r/05_retention_vs_churn_decay.R
# Open powerbi/Executive_Dashboard_Antonio.pbix
```

### 9. Limitations & Next Steps
**Limitations:**
- Public data 2009-2011, single retailer, not generalizable.
- CLV is heuristic, not BG/NBD.
- Dec-09 cohort outlier due to n<50.

**If this were production:**
1. Implement BG/NBD + Gamma-Gamma for probabilistic CLV forecast.
2. A/B test: Day 3 / Day 7 / Day 14 email with 15% coupon targeting Potential Loyalist → measure M1 uplift from 19% to 25%.
3. Market Basket Analysis (Apriori) to pair Champions products with Lost.

### 10. Author
**Antonio Fuentes Moreno** — Seville, Spain
BI Analyst / Data Analyst | Python, R, Power BI, SQL
antonio004fm@gmail.com