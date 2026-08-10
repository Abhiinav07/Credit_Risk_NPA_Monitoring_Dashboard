# Power BI Dashboard Build Guide

## Data
Import `data/loan_portfolio.csv`.

## Model
Single fact table is sufficient for the portfolio demo. For a production model, add Date, Customer, Product and Branch dimensions.

### Suggested measures
```DAX
Total Loans = COUNTROWS(loan_portfolio)
Total Exposure = SUM(loan_portfolio[loan_amount])
NPA Accounts = CALCULATE([Total Loans], loan_portfolio[npa_flag] = 1)
NPA Ratio = DIVIDE([NPA Accounts], [Total Loans])
Avg PD = AVERAGE(loan_portfolio[pd_estimate])
Expected Loss = SUMX(loan_portfolio, loan_portfolio[pd_estimate] * 0.45 * loan_portfolio[loan_amount])
High Risk Exposure = CALCULATE([Total Exposure], loan_portfolio[risk_band] IN {"High","Very High"})
Early Warning Accounts = CALCULATE([Total Loans], loan_portfolio[days_past_due] >= 30, loan_portfolio[days_past_due] < 90)
```

## Page 1 — Executive Risk Overview
- KPI cards: Total Exposure, NPA Ratio, Avg PD, Expected Loss
- Line chart: Monthly NPA Ratio
- Donut: Risk Band distribution
- Bar: NPA Ratio by Region
- Slicer: Application Date, Region, Purpose

## Page 2 — Portfolio & NPA Monitoring
- Clustered bar: Exposure by Purpose
- Column chart: NPA Ratio by Purpose
- Matrix: Region × Risk Band with Exposure and NPA Ratio
- Scatter: Credit Score vs DTI, bubble size = Loan Amount, legend = Risk Band
- Table: Top 25 high-risk / high-exposure accounts

## Page 3 — Early Warning & Applicant Risk
- KPI: Early Warning Accounts
- Bar: Accounts by DPD bucket
- Bar: NPA ratio by DTI bucket
- Bar: NPA ratio by LTV bucket
- Detail table with conditional formatting: loan_id, risk_band, pd_estimate, credit_score, dti_pct, ltv_pct, days_past_due
- Drill-through target: loan-level risk profile

## Recruiter presentation tips
1. Add a title such as “Credit Risk & NPA Command Center”.
2. Use a restrained banking/finance theme.
3. Keep KPI definitions visible in a tooltip or info icon.
4. Add a “Last Refresh” card.
5. Export each page to PDF after the final Power BI build.

**Important:** A native `.pbix` file is a proprietary Power BI Desktop artifact and cannot be reliably generated outside Power BI Desktop. This repository therefore includes the complete Power BI-ready dataset, DAX, layout specification and a recruiter-ready PDF preview. Open Power BI Desktop, follow this guide, and save the resulting file as `Credit_Risk_NPA_Dashboard.pbix`.
