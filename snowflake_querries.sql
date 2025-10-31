--------------AWS_S3_Bucket_integration-----------------------------------------------------------------
CREATE OR REPLACE STORAGE INTEGRATION PBI_INTEGRATION
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://powerbi.project/')
COMMENT = 'optional comment';


SELECT * FROM coffee_shop_sales;
--------------------------------------------------------------------------------------------------------
-----------DTYPE----------------------------------------------------------------------------------------
DESCRIBE TABLE coffee_shop_sales;
---------------------------------------------------------------------------------------------------------
-----------TOTAL SALES-----------------------------------------------------------------------------------
SELECT ROUND(SUM(unit_price * transaction_qty)) as Total_Sales 
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)
---------------------------------------------------------------------------------------------------------
-----------TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH-----------------------------------------------
SELECT 
    EXTRACT(MONTH FROM transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (
        SUM(unit_price * transaction_qty) - 
        LAG(SUM(unit_price * transaction_qty)) 
        OVER (ORDER BY EXTRACT(MONTH FROM transaction_date))
    ) / 
    LAG(SUM(unit_price * transaction_qty)) 
    OVER (ORDER BY EXTRACT(MONTH FROM transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    EXTRACT(MONTH FROM transaction_date) IN (4, 5) -- April and May
GROUP BY 
    EXTRACT(MONTH FROM transaction_date)
ORDER BY 
    month;
-----------------------------------------------------------------------------------------------------
-----------TOTAL ORDERS------------------------------------------------------------------------------
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5 ---May month

-----------TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH-------------------------------------------
WITH monthly_orders AS (
    SELECT 
        MONTH(transaction_date) AS month,
        COUNT(transaction_id) AS total_orders
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) IN (4, 5) -- April & May
    GROUP BY MONTH(transaction_date)
)
SELECT 
    month,
    total_orders,
    ROUND(
        (total_orders - LAG(total_orders) OVER (ORDER BY month)) 
        / LAG(total_orders) OVER (ORDER BY month) * 100,
        2
    ) AS mom_increase_percentage
FROM monthly_orders
ORDER BY month;
--------------------------------------------------------------------------------------------------------
------------TOTAL QUANTITY SOLD------------------------------------------------------------------------
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)
--------------------------------------------------------------------------------------------------------
------------TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH-------------------------------------
WITH monthly_sales AS (
    SELECT 
        MONTH(transaction_date) AS month,
        ROUND(SUM(transaction_qty)) AS total_quantity_sold
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) IN (4, 5)   -- for April and May
    GROUP BY MONTH(transaction_date)
)
SELECT 
    month,
    total_quantity_sold,
    ROUND(
        (total_quantity_sold - LAG(total_quantity_sold) OVER (ORDER BY month)) 
        / LAG(total_quantity_sold) OVER (ORDER BY month) * 100,
        2
    ) AS mom_increase_percentage
FROM monthly_sales
ORDER BY month;
-----------------------------------------------------------------------------------------------------------
----------CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS------------------------------------------
SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM coffee_shop_sales
WHERE transaction_date = DATE '2023-05-18';  -- For 18 May 2023
-----------------------------------------------------------------------------------------------------------
----------CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS WITH 'K'---------------------------------
SELECT 
    ROUND(SUM(unit_price * transaction_qty) / 1000, 1) || 'K' AS total_sales,
    ROUND(COUNT(transaction_id) / 1000, 1) || 'K' AS total_orders,
    ROUND(SUM(transaction_qty) / 1000, 1) || 'K' AS total_quantity_sold
FROM coffee_shop_sales
WHERE transaction_date = DATE '2023-05-18';  -- For 18 May 2023

------------------------------------------------------------------------------------------------------
-- WEEK ENDS = SUNDAY & SATURDAY ; SUNDAY = 1,MONDAY = 2, TUSEDAY = 3, ........SATURDAY = 7
-- WEEK DAYS = MONDAT TO FRIDAY
-------------------------------------------------------------------------------------------------------
----------------------SALES BY WEEKDAY / WEEKEND:------------------------------------------------------
SELECT 
    CASE 
        WHEN (DAYOFWEEK(transaction_date) + 1) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY 
    CASE 
        WHEN (DAYOFWEEK(transaction_date) + 1) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;
    
----------------------------------------------------------------------------------------------------------
--------------------------SALES BY WEEKDAY / WEEKEND: IN 'K'---------------------------------------------
SELECT 
    CASE 
        WHEN (DAYOFWEEK(transaction_date) + 1) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty)/1000, 1) || 'K' AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN (DAYOFWEEK(transaction_date) + 1) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;
-----------------------------------------------------------------------------------------------------------
------------------------SALES BY STORE LOCATION------------------------------------------------
SELECT 
    store_location,
    SUM(unit_price * transaction_qty) AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY store_location
ORDER BY SUM(unit_price * transaction_qty) DESC;
------------------------------------------------------------------------------------------------------------------------------------SALES BY STORE LOCATION WITH 'K'--------------------------------------------------
SELECT 
    store_location,
    ROUND(SUM(unit_price * transaction_qty) / 1000, 2) || 'K' AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY store_location
ORDER BY SUM(unit_price * transaction_qty) DESC;
--------------------------------------------------------------------------------------------------------------------------------------- SALES TREND OVER PERIOD ------------------------------------------------------
SELECT AVG(total_sales) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM coffee_shop_sales
    WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
    GROUP BY transaction_date
) AS internal_query;
----------------------------------------------------------------------------------------------------------------------------------------DAILY SALES FOR MONTH SELECTED------------------------------------------------
SELECT 
    DAYOFMONTH(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty), 1) AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY DAYOFMONTH(transaction_date)
ORDER BY day_of_month;
-------------------------------------------------------------------------------------------------------------COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”-------
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAYOFMONTH(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM coffee_shop_sales
    WHERE EXTRACT(MONTH FROM transaction_date) = 5  -- Filter for May
    GROUP BY DAYOFMONTH(transaction_date)
) AS sales_data
ORDER BY day_of_month;
---------------------------------------------------------------------------------------------------------------------------SALES BY PRODUCT CATEGORY
SELECT 
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 1) AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC;
----------------------------------------------------------------------------------------------------------------------------- SALES BY PRODUCTS (TOP 10)--------------------------------------------------------------------------
SELECT 
    product_type,
    ROUND(SUM(unit_price * transaction_qty), 1) AS total_sales
FROM coffee_shop_sales
WHERE EXTRACT(MONTH FROM transaction_date) = 5   -- Filter for May
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;
----------------------------------------------------------------------------------------------------------------
-----------------------------SALES BY DAY | HOUR
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    SUM(transaction_qty) AS total_quantity,
    COUNT(*) AS total_orders
FROM coffee_shop_sales
WHERE 
    (DAYOFWEEK(transaction_date) + 1) = 3   -- Tuesday (1=Sunday ... 7=Saturday)
    AND DATE_PART(HOUR, transaction_time) = 8  -- Hour 8 AM
    AND EXTRACT(MONTH FROM transaction_date) = 5;  -- May
---------------------------------------------------------------------------------------------------------------------
---------------------TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY--------------------------------------------------
SELECT
    CASE
        WHEN DAYOFWEEKISO(transaction_date) = 1 THEN 'Monday'
        WHEN DAYOFWEEKISO(transaction_date) = 2 THEN 'Tuesday'
        WHEN DAYOFWEEKISO(transaction_date) = 3 THEN 'Wednesday'
        WHEN DAYOFWEEKISO(transaction_date) = 4 THEN 'Thursday'
        WHEN DAYOFWEEKISO(transaction_date) = 5 THEN 'Friday'
        WHEN DAYOFWEEKISO(transaction_date) = 6 THEN 'Saturday'
        WHEN DAYOFWEEKISO(transaction_date) = 7 THEN 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) = 5
GROUP BY
    Day_of_Week,
    -- Grouping by the numerical value for correct ordering of the days
    DAYOFWEEKISO(transaction_date)
ORDER BY
    DAYOFWEEKISO(transaction_date);
----------------------------------------------------------------------------------------------------------------------------------------






