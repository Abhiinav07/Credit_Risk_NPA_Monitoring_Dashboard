# Credit Risk Profiling & NPA Monitoring Dashboard

> End-to-end Finance & Banking portfolio project demonstrating credit-risk analytics, probability-of-default scoring, early-warning monitoring, SQL analysis, Excel decision support and Power BI dashboard design.

## Business problem
A retail bank wants to reduce its Non-Performing Asset (NPA) ratio and improve loan approval decisions. This project scores applicants by risk level, identifies early-warning signals and creates an executive monitoring layer for the credit-risk team.

## What this repository contains

| Deliverable | File |
|---|---|
| Loan dataset | `data/loan_portfolio.csv` |
| Data dictionary | `data/data_dictionary.csv` |
| 15 analytical SQL queries | `sql/credit_risk_analysis.sql` |
| PD calculator | `excel/PD_Calculator.xlsx` |
| EDA + risk scoring notebook | `notebooks/credit_risk_analysis.ipynb` |
| Power BI DAX measures | `powerbi/measures.dax` |
| Power BI build specification | `powerbi/POWER_BI_BUILD_GUIDE.md` |
| 3-page dashboard preview | `dashboard/Credit_Risk_NPA_Dashboard.pdf` |
| Model scoring output | `outputs/model_scoring_output.csv` |

## Methodology
1. Generate a reproducible synthetic retail-loan portfolio.
2. Explore portfolio quality, delinquency and concentration.
3. Engineer credit-risk variables such as DTI, LTV and delinquency history.
4. Train a logistic-regression PD model with preprocessing and class balancing.
5. Segment applicants into Low / Moderate / High / Very High risk.
6. Create early-warning rules using DPD, bureau score, DTI, LTV and prior delinquency.
7. Use SQL for portfolio-level monitoring and expected-loss analysis.
8. Provide an Excel PD calculator for transparent scenario testing.
9. Build a 3-page Power BI command-center design.

## Tech stack
**Python:** pandas, NumPy, scikit-learn, matplotlib  
**SQL:** PostgreSQL-compatible analytical SQL  
**Excel:** formulas, data validation and sensitivity analysis  
**Power BI:** DAX, interactive slicers, risk segmentation and drill-through design

## Running the project

### Python
```bash
pip install -r requirements.txt
jupyter notebook notebooks/credit_risk_analysis.ipynb
```

### SQL
Load `data/loan_portfolio.csv` into a table named `loan_portfolio`, then run `sql/credit_risk_analysis.sql`.

### Power BI
Open Power BI Desktop, import `data/loan_portfolio.csv`, add the measures from `powerbi/measures.dax`, and follow `powerbi/POWER_BI_BUILD_GUIDE.md`.

## Power BI `.pbix`
A native `.pbix` file is generated and saved by Power BI Desktop. It cannot be reliably authored by this repository-generation environment. To complete the native Power BI artifact, open the supplied dataset and build guide in Power BI Desktop and save the file as:

`powerbi/Credit_Risk_NPA_Dashboard.pbix`

The repository already contains the full data, DAX, page specification and a PDF dashboard preview so the project is reviewable immediately.
