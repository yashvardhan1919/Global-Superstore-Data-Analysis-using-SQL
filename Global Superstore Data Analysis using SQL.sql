USE INDEXING;
-- 1. Find the Total Revenue and Profit generated.

SELECT 
    ROUND(SUM(SALES),2) AS TOTAL_REVENUE,
    ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM SUPERSTORE;

-- 2. Find the Segment-wise distribution of Sales.

SELECT 
    SEGMENT,
    ROUND(SUM(SALES),2) AS TOTAL_SALES
FROM SUPERSTORE
GROUP BY SEGMENT
ORDER BY TOTAL_SALES DESC;

-- 3. Find the Top 3 Most Profitable Products.

SELECT 
    `PRODUCT NAME`,
    ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM SUPERSTORE
GROUP BY `PRODUCT NAME`
ORDER BY TOTAL_PROFIT DESC
LIMIT 3;

-- 4. Find Number of Orders Placed After January 2016.

SELECT 
    COUNT(*) AS ORDERS_AFTER_JAN2016
FROM SUPERSTORE
WHERE `ORDER DATE` > '2016-01-31';

-- 5️. Find Number of States from Mexico

SELECT 
    COUNT(DISTINCT STATE) AS STATES_FROM_MEXICO
FROM SUPERSTORE
WHERE COUNTRY = 'Mexico';

-- 6. which products and subcategories are most and least profitable ?

SELECT `PRODUCT NAME`,
       ROUND(SUM(PROFIT),2) AS total_profit,
       ROUND(SUM(SALES),2)  AS total_sales
FROM SUPERSTORE
GROUP BY `PRODUCT NAME`
ORDER BY total_profit DESC
LIMIT 5;

-- 7. Which customer segment contributes the most to the total revenue?

SELECT SEGMENT,
       ROUND(SUM(SALES),2) AS total_sales
FROM SUPERSTORE
GROUP BY SEGMENT
ORDER BY total_sales DESC
LIMIT 1;

-- 8. What is the year-over-year growth in sales and Profit?

CREATE INDEX IDX_ORDER_DATE ON SUPERSTORE(`Order Date`);

SELECT 
    YEAR(`Order Date`) AS Year,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(
        ((SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR(`Order Date`))) 
        / LAG(SUM(Sales)) OVER (ORDER BY YEAR(`Order Date`))) * 100, 2
    ) AS Sales_Growth_Percent,
    ROUND(
        ((SUM(Profit) - LAG(SUM(Profit)) OVER (ORDER BY YEAR(`Order Date`))) 
        / LAG(SUM(Profit)) OVER (ORDER BY YEAR(`Order Date`))) * 100, 2
    ) AS Profit_Growth_Percent
FROM SUPERSTORE
GROUP BY YEAR(`Order Date`)
ORDER BY YEAR(`Order Date`) DESC
LIMIT 10;


-- 9. Which countries and cities are driving the highest sales?

SELECT COUNTRY,
       ROUND(SUM(SALES),2) AS total_sales,
       ROUND(SUM(PROFIT),2) AS total_profit
FROM SUPERSTORE
GROUP BY COUNTRY
ORDER BY total_sales DESC
LIMIT 20;

-- 10. What is the average delivery time from order to ship date across regions?

SELECT REGION,
       ROUND(AVG(DATEDIFF(`SHIP DATE`, `ORDER DATE`)),2) AS avg_delivery_days,
       MIN(DATEDIFF(`SHIP DATE`, `ORDER DATE`)) AS min_delivery_days,
       MAX(DATEDIFF(`SHIP DATE`, `ORDER DATE`)) AS max_delivery_days
FROM SUPERSTORE
GROUP BY REGION
ORDER BY avg_delivery_days DESC;

-- 11. what is the profit distribution across order priority?

SELECT `ORDER PRIORITY`,
       COUNT(*)               AS orders,
       ROUND(SUM(SALES),2)    AS total_sales,
       ROUND(SUM(PROFIT),2)   AS total_profit,
       ROUND(AVG(PROFIT),2)   AS avg_profit_per_order,
       ROUND(STDDEV_SAMP(PROFIT),2) AS profit_stddev   -- or STDDEV(PROFIT) depending on DB
FROM SUPERSTORE
GROUP BY `ORDER PRIORITY`
ORDER BY total_profit ;

-- 12. Suggest data-driven recommendations for improving profit and reducing losses.

CREATE INDEX IDX_CAT_SUB_PROD ON SUPERSTORE(`Category`(30), `Sub-Category`(50), `Product Name`(100));

SELECT
    `Category`,
    `Sub-Category`,
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Discount) AS Avg_Discount
FROM SUPERSTORE
GROUP BY `Category`, `Sub-Category`, `Product Name`
HAVING SUM(Profit) < 5 OR SUM(Profit) < 0.05 * SUM(Sales)
ORDER BY Total_Profit ASC
LIMIT 10;




  