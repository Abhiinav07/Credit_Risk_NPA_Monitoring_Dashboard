-- Credit Risk Profiling & NPA Monitoring
-- Dialect: PostgreSQL-compatible SQL
-- Dataset: data/loan_portfolio.csv loaded as loan_portfolio

-- 1. Portfolio KPIs
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_exposure,
    AVG(pd_estimate) AS avg_pd,
    AVG(npa_flag::int) AS npa_ratio,
    AVG(default_flag::int) AS default_rate
FROM loan_portfolio;

-- 2. NPA ratio by region
SELECT region,
       COUNT(*) AS loans,
       SUM(loan_amount) AS exposure,
       ROUND(100.0 * AVG(npa_flag::int), 2) AS npa_ratio_pct
FROM loan_portfolio
GROUP BY region
ORDER BY npa_ratio_pct DESC;

-- 3. NPA ratio by risk band
SELECT risk_band,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(npa_flag::int), 2) AS npa_ratio_pct,
       ROUND(AVG(pd_estimate)::numeric, 4) AS avg_pd
FROM loan_portfolio
GROUP BY risk_band
ORDER BY avg_pd DESC;

-- 4. High-risk exposure
SELECT
    risk_band,
    SUM(loan_amount) AS exposure,
    COUNT(*) AS accounts
FROM loan_portfolio
WHERE risk_band IN ('High','Very High')
GROUP BY risk_band
ORDER BY exposure DESC;

-- 5. Early-warning loans: DPD 30-89
SELECT loan_id, risk_band, credit_score, dti_pct, ltv_pct,
       prior_delinquencies, days_past_due, loan_amount
FROM loan_portfolio
WHERE days_past_due BETWEEN 30 AND 89
ORDER BY days_past_due DESC, pd_estimate DESC;

-- 6. Severe delinquency / NPA accounts
SELECT loan_id, days_past_due, loan_amount, pd_estimate,
       risk_band, credit_score, dti_pct, ltv_pct
FROM loan_portfolio
WHERE days_past_due >= 90
ORDER BY loan_amount DESC;

-- 7. Credit score buckets
SELECT
    CASE
        WHEN credit_score < 600 THEN '<600'
        WHEN credit_score < 650 THEN '600-649'
        WHEN credit_score < 700 THEN '650-699'
        WHEN credit_score < 750 THEN '700-749'
        ELSE '750+'
    END AS score_bucket,
    COUNT(*) AS loans,
    ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct,
    ROUND(AVG(pd_estimate)::numeric,4) AS avg_pd
FROM loan_portfolio
GROUP BY 1
ORDER BY 1;

-- 8. DTI risk segmentation
SELECT
    CASE
        WHEN dti_pct < 25 THEN '<25%'
        WHEN dti_pct < 40 THEN '25-39%'
        WHEN dti_pct < 55 THEN '40-54%'
        ELSE '55%+'
    END AS dti_bucket,
    COUNT(*) AS loans,
    ROUND(100.0*AVG(default_flag::int),2) AS default_rate_pct,
    ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct
FROM loan_portfolio
GROUP BY 1
ORDER BY 1;

-- 9. LTV risk segmentation
SELECT
    CASE
        WHEN ltv_pct < 60 THEN '<60%'
        WHEN ltv_pct < 75 THEN '60-74%'
        WHEN ltv_pct < 90 THEN '75-89%'
        ELSE '90%+'
    END AS ltv_bucket,
    COUNT(*) AS loans,
    ROUND(AVG(ltv_pct)::numeric,2) AS avg_ltv,
    ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct
FROM loan_portfolio
GROUP BY 1
ORDER BY 1;

-- 10. Product / purpose performance
SELECT purpose,
       COUNT(*) AS loans,
       SUM(loan_amount) AS exposure,
       ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct,
       ROUND(AVG(pd_estimate)::numeric,4) AS avg_pd
FROM loan_portfolio
GROUP BY purpose
ORDER BY npa_ratio_pct DESC;

-- 11. Employment type performance
SELECT employment_type,
       COUNT(*) AS loans,
       ROUND(100.0*AVG(default_flag::int),2) AS default_rate_pct,
       ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct
FROM loan_portfolio
GROUP BY employment_type
ORDER BY default_rate_pct DESC;

-- 12. Monthly NPA trend
SELECT DATE_TRUNC('month', application_date) AS month,
       COUNT(*) AS loans,
       SUM(loan_amount) AS exposure,
       ROUND(100.0*AVG(npa_flag::int),2) AS npa_ratio_pct
FROM loan_portfolio
GROUP BY 1
ORDER BY 1;

-- 13. Top 25 exposure accounts with risk signals
SELECT loan_id, loan_amount, risk_band, pd_estimate, credit_score,
       dti_pct, ltv_pct, prior_delinquencies, days_past_due
FROM loan_portfolio
ORDER BY loan_amount DESC
LIMIT 25;

-- 14. Applicants with multiple warning signals
SELECT loan_id, risk_band, pd_estimate, credit_score, dti_pct,
       ltv_pct, prior_delinquencies, days_past_due
FROM loan_portfolio
WHERE (credit_score < 650)::int
    + (dti_pct >= 50)::int
    + (ltv_pct >= 85)::int
    + (prior_delinquencies >= 2)::int
    + (days_past_due >= 30)::int >= 3
ORDER BY pd_estimate DESC;

-- 15. Expected loss estimate
-- EL = PD * LGD * EAD. Assumption: LGD = 45%.
SELECT
    SUM(pd_estimate * 0.45 * loan_amount) AS expected_loss,
    SUM(loan_amount) AS exposure,
    ROUND(100.0*SUM(pd_estimate*0.45*loan_amount)/SUM(loan_amount),2) AS expected_loss_rate_pct
FROM loan_portfolio;
