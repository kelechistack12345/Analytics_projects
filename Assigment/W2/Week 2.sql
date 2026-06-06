CREATE OR REPLACE WAREHOUSE ASSIGMENT_WH
  WITH WAREHOUSE_SIZE = '6X-LARGE'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

  CREATE OR REPLACE DATABASE ASSIGMENT_DB

  CREATE OR REPLACE SCHEMA ASSIGMENT_SCHEMA

  CREATE OR REPLACE TABLE web_events (
	id integer NOT NULL PRIMARY KEY,
	account_id integer,
	occurred_at date,
	channel varchar (50)
);
SELECT * FROM ASSIGMENT_SCHEMA.WEB_EVENTS

CREATE OR REPLACE TABLE sales_reps (
	id integer NOT NULL PRIMARY KEY,
	name varchar (50) NOT NULL,
	region_id integer NOT NULL
);

SELECT * FROM ASSIGMENT_SCHEMA.SALES_REPS

CREATE OR REPLACE TABLE region (
	id integer NOT NULL PRIMARY KEY,
	name varchar (50)
);
INSERT INTO region VALUES (1,'Northeast');
INSERT INTO region VALUES (2,'Midwest');
INSERT INTO region VALUES (3,'Southeast');
INSERT INTO region VALUES (4,'West');

SELECT * FROM REGION

CREATE OR REPLACE TABLE orders (
	id integer NOT NULL PRIMARY KEY,
	account_id integer,
	occurred_at date,
	standard_qty integer,
	gloss_qty integer,
	poster_qty integer,
	total integer,
	standard_amt_usd numeric(10,2),
	gloss_amt_usd numeric(10,2),
	poster_amt_usd numeric(10,2),
	total_amt_usd numeric(10,2)
);

SELECT ACCOUNT_ID FROM ORDERS WHERE ACCOUNT_ID = 4211

CREATE OR REPLACE TABLE accounts (
	id integer NOT NULL PRIMARY KEY,
	name varchar (50) NOT NULL,
	website varchar (50),
	lat numeric(11,8),
	long numeric(11,8),
	primary_poc varchar (50),
	sales_rep_id integer
);

SELECT * FROM ASSIGMENT_SCHEMA.ACCOUNTS

/*Question 1 — Top Revenue-Generating Accounts
Business Problem*/

SELECT TOP 10
    A.ID,
    A.NAME,
    A.PRIMARY_POC,
    B.ACCOUNT_ID,
    SUM(B.TOTAL_AMT_USD) AS TOTAL_AMT_USD
FROM ASSIGMENT_SCHEMA.ACCOUNTS A
JOIN ASSIGMENT_SCHEMA.ORDERS B
    ON A.ID = B.ACCOUNT_ID
GROUP BY
    A.ID,
    A.NAME,
    A.PRIMARY_POC,
    B.ACCOUNT_ID
ORDER BY
    TOTAL_AMT_USD DESC;


/*Question 2 — Monthly Revenue Trend
Business Problem */

SELECT 
   CONCAT(MONTHNAME(A.OCCURRED_AT),' ',YEAR(A.OCCURRED_AT)) AS MM_YY,
   CEIL(SUM(B.TOTAL_AMT_USD)) AS TOTAL_AMOUNT 
FROM WEB_EVENTS A
JOIN ORDERS B
    ON A.ACCOUNT_ID = B.ACCOUNT_ID
GROUP BY
   MONTHNAME(A.OCCURRED_AT),
   YEAR(A.OCCURRED_AT)
ORDER BY 
    TOTAL_AMOUNT DESC;

/*Question 3 — Customer Segmentation by Revenue
Business Problem*/

SELECT 
    A.NAME,
    CEIL(SUM(B.TOTAL_AMT_USD)) AS TOTAL_AMOUNT,
    CASE
        WHEN CEIL(SUM(B.TOTAL_AMT_USD)) >= 200000 THEN 'Enterprise'
        WHEN CEIL(SUM(B.TOTAL_AMT_USD)) >= 100000
             AND CEIL(SUM(B.TOTAL_AMT_USD)) < 200000 THEN 'Mid-Market'
        ELSE 'Small Business'
    END AS CUSTOMER_SEGMENT_BY_REVENUE
FROM ACCOUNTS A
JOIN ORDERS B
    ON A.ID = B.ACCOUNT_ID
GROUP BY
    A.NAME
ORDER BY
    TOTAL_AMOUNT DESC; 

/*Question 4 — Most Effective Marketing Channel
Business Problem*/
    

SELECT
    CHANNEL,
    COUNT(*) AS OCCURANCE
FROM WEB_EVENTS
GROUP BY
    CHANNEL
ORDER BY
    OCCURANCE DESC
    LIMIT 1;

/*Question 5 — Average Order Value by Region
Business Problem*/

SELECT 
    D.NAME,
    SUM(a.total_amt_usd) AS SALES_AMOUNT,
    CEIL(AVG(a.total_amt_usd)) AS AVG_SALES_AMOUNT
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID
JOIN SALES_REPS C
    ON B.SALES_REP_ID = C.ID
JOIN REGION D ON C.REGION_ID = D.ID
GROUP BY D.NAME
ORDER BY SALES_AMOUNT DESC;

/*Question 6 — Sales Rep Performance Ranking*/

SELECT 
    C.NAME,
    SUM(a.total_amt_usd) AS SALES_AMOUNT
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID
JOIN SALES_REPS C
    ON B.SALES_REP_ID = C.ID
JOIN REGION D ON C.REGION_ID = D.ID
GROUP BY C.NAME
ORDER BY SALES_AMOUNT DESC;

/*SELECT
    A.GLOSS_QTY,
    A.POSTER_QTY,
    A.STANDARD_QTY
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID;*/

/*Identify Inactive Customers*/

SELECT
    B.NAME,
    A.OCCURRED_AT,
    SUM(A.STANDARD_QTY) AS QTY,
    SUM(A.TOTAL_AMT_USD) AS VALUE
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID
GROUP BY
    B.NAME,
    A.OCCURRED_AT
HAVING SUM(A.STANDARD_QTY) = 0
ORDER BY VALUE DESC;

/* Detect High-Value Orders*/
SELECT 
    B.NAME,
    A.STANDARD_QTY
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID
WHERE A.STANDARD_QTY > 2000
ORDER BY A.STANDARD_QTY DESC;

/* Customer Purchase Frequency*/
SELECT 
    B.NAME,
    COUNT(A.STANDARD_QTY) AS COUNT_ORDERS
FROM ORDERS A
JOIN ACCOUNTS B
    ON A.ACCOUNT_ID = B.ID
GROUP BY B.NAME
ORDER BY COUNT_ORDERS DESC;

















    










    



    


    



















  

  
    