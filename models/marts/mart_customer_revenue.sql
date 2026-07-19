{{config(materalized='table',schema='MARTS')}}


SELECT
    d.ACCOUNT_ID,
    d.ACCOUNT_NAME,
    COUNT(f.ORDERS_ID) AS ORDER_COUNT,
    SUM(f.TOTAL_AMT_USD) AS TOTAL_REVENUE,
    AVG(f.TOTAL_AMT_USD) AS AVG_ORDER_VALUE
FROM  {{ref('dim_account')}} d
JOIN  {{ref('facts_orders')}}  f
ON d.ACCOUNT_ID = f.ACCOUNT_ID
GROUP BY
    d.ACCOUNT_ID,
    d.ACCOUNT_NAME

