--The first step i took was to clean the data using excel

--To create a table named nse
CREATE TABLE nse(
Date    	      DATE,
Opening_price     NUMERIC,
High              NUMERIC,
Low       		  NUMERIC,
Closing_price     NUMERIC,
Volume     		  NUMERIC,
Change_pct        NUMERIC
);

--I used the Import?Export option to import the cleaned data

SELECT * FROM nse;

--Below are the ready-to-use SQL queries for the KPI's:
--1. Highest Daily Return

SELECT date, change_pct daily_return
FROM nse
ORDER BY change_pct DESC
LIMIT 1;

--2. Average monthly close
SELECT DATE_TRUNC('month', "date") AS month, ROUND(AVG(closing_price), 2) avg_monthly_close
FROM nse
GROUP BY month
ORDER BY month;

--3. Monthly volatility trend
SELECT DATE_TRUNC('month', "date") AS month, ROUND(STDDEV(change_pct), 2) AS monthly_volatility
FROM nse
GROUP BY month
ORDER BY month;

--4. 5 lowest drawdown period
-- First: Get running max and drawdown
WITH running_data AS (
    SELECT "date", "closing_price", MAX("closing_price") OVER (ORDER BY "date") AS running_max,
        ("closing_price" - MAX("closing_price") OVER (ORDER BY "date")) / MAX("closing_price") OVER (ORDER BY "date") AS drawdown
    FROM nse
)
SELECT "date", "closing_price", running_max, ROUND(drawdown * 100, 2) AS drawdown_pct
FROM running_data
ORDER BY drawdown ASC
LIMIT 5;

--5. Last 30-day average return
SELECT AVG("change_pct") AS avg_return_last_30_days
FROM (
    SELECT "change_pct"
    FROM nse
    ORDER BY "date" DESC
    LIMIT 30
) AS recent;




