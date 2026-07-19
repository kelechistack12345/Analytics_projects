{{config(materalized='table',schema='MARTS')}}

SELECT
    s.SALES_REPS_ID,
    s.SALES_REPS_NAME,
    COUNT(DISTINCT a.ACCOUNT_ID) AS ACCOUNTS_MANAGED,
    SUM(f.TOTAL_AMT_USD) AS TOTAL_REVENUE
FROM {{ref('dim_sales_reps')}} s
JOIN {{ref('dim_account')}} a
    ON s.SALES_REPS_ID = a.SALES_REP_ID
JOIN {{ref('facts_orders')}} f
    ON a.ACCOUNT_ID = f.ACCOUNT_ID
GROUP BY
    s.SALES_REPS_ID,
    s.SALES_REPS_NAME