# E-commerce Sales & Customer Analytics
### A BI Consulting Engagement — RFM Segmentation, Sales Diagnostics & Retention Audit

<p align="left">
<img src="https://img.shields.io/badge/R-4.x-276DC3?style=flat-square&logo=r&logoColor=white" alt="R">
<img src="https://img.shields.io/badge/Python-3.x-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python">
<img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat-square&logo=powerbi&logoColor=black" alt="Power BI">
<img src="https://img.shields.io/badge/Statistical%20Validation-ANOVA-4CAF50?style=flat-square" alt="Statistical Validation">
<img src="https://img.shields.io/badge/License-MIT-4CAF50?style=flat-square" alt="MIT License">
</p>

---

## Engagement Overview

A retail client needs three questions answered before they can act: **where is revenue concentrated, which customers are worth protecting, and where does retention break down.** This project answers all three, using 1.07M real transactions from a UK-based online retailer (Dec 2009 – Dec 2011), through a full pipeline of Python data engineering, R statistical validation, and an executive Power BI dashboard — structured and validated the way a BI consultancy would deliver it to a client. Every finding below is backed by a statistical test, not a visual impression.

---

## Key Business Findings

| Metric | Value |
|---|---|
| Active customers analyzed | 5,878 |
| Total revenue | £7,211,416 |
| Total units sold | 11M |
| Champion segment share | 22.12% of customers |
| Avg. revenue per customer (mean) | £1,227 |
| Median customer lifetime value (3-yr est.) | £1,334.67 |
| Month-1 customer retention | 19% (81% churn) |
| Month-3 customer retention | 13% |
| UK share of sales volume | 81% |
| Peak sales month | November 2011 — 1.24M units |
| Cohorts tracked | 25 monthly cohorts, 24-month window |

**Headline insight:** Champions — 22% of the customer base — drive 17x higher purchase frequency and a ~£3,800 higher median spend than the Lost segment (26% of customers). At the same time, 81% of customers churn after their first month. **The highest-leverage lever in this business isn't acquisition — it's the first 30 days after a customer's first purchase.**

---

## Dashboard

Three-page executive Power BI dashboard, built to consulting-deliverable standard — KPI cards, statistically validated insights, and a closing recommendation on every page.

### Page 1 — Customer Segmentation


![Customer Segmentation Dashboard](report/screenshots/page1_segmentation.png)


RFM segmentation across six actionable segments. Combo chart isolates purchase frequency from spend so high-value outliers don't flatten the other five segments.

### Page 2 — Sales Performance


![Sales Performance Dashboard](report/screenshots/page2_sales.png)


Monthly volume by segment and geographic concentration. UK excluded from the market-comparison chart by design — at 81% of volume, including it renders every other market illegible.

### Page 3 — Customer Retention


![Retention Dashboard](report/screenshots/page3_retention.png)


Custom cohort retention heatmap (R/ggplot2) paired with a churn-decay curve visualizing the 81% first-month churn cliff against the 19% retention line.

---

## Methodology

| Step | Tool | What it does |
|---|---|---|
| Data preparation | Python — `pandas` | Merges source sheets, removes cancellations and unattributable orders, computes line-level revenue. 806K clean rows retained. |
| RFM segmentation | Python — `pandas` | Quintile-scores Recency, Frequency, Monetary; maps to 6 named segments. |
| Cohort retention | Python — `pandas` | Tracks 25 monthly cohorts across a 24-month window. |
| Statistical validation | R — `aov()`, `TukeyHSD()` | Confirms findings aren't noise (see below). |
| Dashboard | Power BI — DAX | Executive-facing 3-page report. |

**Validation results:**

| Test | Result |
|---|---|
| ANOVA — Monetary value by RFM segment | p = 3.18 × 10⁻⁶⁸ |
| ANOVA — Revenue by calendar month (seasonality) | p = 1.43 × 10⁻⁸ |
| CLV (3-yr heuristic) | Median £1,334.67 |

Full methodology, DAX measures, and reproduction steps: [`docs/technical_documentation.md`](docs/technical_documentation.md)

---

## Repository Structure

```
ecommerce-sales-customer-analytics/
├── data/
│   ├── raw/                  ← place online_retail_ii.xlsx here (not tracked in repo)
│   └── processed/
├── notebooks/
│   ├── 01_data_preparation.ipynb
│   ├── 02_rfm_segmentation.ipynb
│   └── 03_cohort_analysis.ipynb
├── r/
│   ├── 04_statistical_validation.R
│   └──05_retention_vs_churn_decay.R
├── powerbi/
│   └── Executive_Dashboard_Antonio.pbix
├── report/
├── screenshots/
├── figures/
├── docs/
│   └── technical_documentation.md
├── requirements.txt
├── .gitignore
├── LICENSE
└── README.md
```

---

## How to Reproduce

```bash
git clone https://github.com/FuentesAntro/ecommerce-sales-customer-analytics.git
cd ecommerce-sales-customer-analytics

python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Download the dataset (see Data Source below) → data/raw/online_retail_ii.xlsx

jupyter notebook notebooks/01_data_preparation.ipynb
jupyter notebook notebooks/02_rfm_segmentation.ipynb
jupyter notebook notebooks/03_cohort_analysis.ipynb

cd r && Rscript 04_statistical_validation.R

# Open powerbi/RFM_Dashboard_Antonio.pbix in Power BI Desktop
```

---

## Next Steps

This engagement demonstrates the methodology end-to-end. A production version would extend it with:
- **Probabilistic CLV** (BG/NBD model) instead of the current 3-year heuristic, for forecasting rather than diagnostics
- **An A/B test proposal** targeting the Day 1–30 window, where 81% of churn concentrates
- **Market basket analysis** (association rules) to convert the cross-sell opportunity into specific product recommendations

---

## Scope and Limitations

- Public transactional data from a single UK-based retailer (2009–2011); findings demonstrate methodology, not generalizable market conclusions.
- CLV uses a documented 3-year heuristic, not a probabilistic model — appropriate for diagnostics, not forecasting.
- The Dec-2009 cohort shows anomalously high retention due to small sample size and is treated as a statistical outlier in comparisons.

---

## Data Source

Chen, D. (2019). *Online Retail II Dataset.* UCI Machine Learning Repository. https://archive.ics.uci.edu/dataset/502/online+retail+ii

---

## Author

**Antonio Fuentes Moreno**

📍 Seville, Spain · [LinkedIn](#) · [GitHub](https://github.com/FuentesAntro)

**License:** MIT
