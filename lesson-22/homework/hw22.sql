/* ===============================================
   Lesson 22 - Aggregated Window Functions
   =============================================== */

-------------------------------------
-- 1. Compute Running Total Sales per Customer
-------------------------------------
SELECT sale_id, customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM sales_data;

-------------------------------------
-- 2. Count the Number of Orders per Product Category
-------------------------------------
SELECT DISTINCT product_category,
       COUNT(*) OVER (PARTITION BY product_category) AS OrdersPerCategory
FROM sales_data;

-------------------------------------
-- 3. Find the Maximum Total Amount per Product Category
-------------------------------------
SELECT DISTINCT product_category,
       MAX(total_amount) OVER (PARTITION BY product_category) AS MaxAmount
FROM sales_data;

-------------------------------------
-- 4. Find the Minimum Price of Products per Product Category
-------------------------------------
SELECT DISTINCT product_category,
       MIN(unit_price) OVER (PARTITION BY product_category) AS MinPrice
FROM sales_data;

-------------------------------------
-- 5. Compute the Moving Average of Sales of 3 days (prev, curr, next)
-------------------------------------
SELECT order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM sales_data;

-------------------------------------
-- 6. Find the Total Sales per Region
-------------------------------------
SELECT DISTINCT region,
       SUM(total_amount) OVER (PARTITION BY region) AS TotalSalesRegion
FROM sales_data;

-------------------------------------
-- 7. Rank Customers Based on Their Total Purchase Amount
-------------------------------------
SELECT customer_id, customer_name,
       SUM(total_amount) AS TotalSpent,
       DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS RankBySpending
FROM sales_data
GROUP BY customer_id, customer_name;

-------------------------------------
-- 8. Difference Between Current and Previous Sale Amount per Customer
-------------------------------------
SELECT sale_id, customer_id, customer_name, order_date, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS DiffPrev
FROM sales_data;

-------------------------------------
-- 9. Top 3 Most Expensive Products in Each Category
-------------------------------------
SELECT sale_id, product_category, product_name, unit_price
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
    FROM sales_data
) t
WHERE rnk <= 3;

-------------------------------------
-- 10. Cumulative Sum of Sales Per Region by Order Date
-------------------------------------
SELECT sale_id, region, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS CumSales
FROM sales_data;

/* ============================
   MEDIUM QUESTIONS
   ============================ */

-------------------------------------
-- 11. Compute Cumulative Revenue per Product Category
-------------------------------------
SELECT product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS CumRevenue
FROM sales_data;

-------------------------------------
-- 12. Sum of Previous Values to Current Value (OneColumn table)
-------------------------------------
SELECT Value,
       SUM(Value) OVER (ORDER BY Value ROWS UNBOUNDED PRECEDING) AS [Sum of Previous]
FROM OneColumn;

-------------------------------------
-- 13. Customers who purchased from more than one product_category
-------------------------------------
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-------------------------------------
-- 14. Customers with Above-Average Spending in Their Region
-------------------------------------
SELECT customer_id, customer_name, region,
       SUM(total_amount) AS TotalSpent,
       AVG(SUM(total_amount)) OVER (PARTITION BY region) AS AvgRegionSpending
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING SUM(total_amount) > AVG(SUM(total_amount)) OVER (PARTITION BY region);

-------------------------------------
-- 15. Rank customers based on spending within each region
-------------------------------------
SELECT customer_id, customer_name, region,
       SUM(total_amount) AS TotalSpent,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS RankInRegion
FROM sales_data
GROUP BY customer_id, customer_name, region;

-------------------------------------
-- 16. Running total (cumulative_sales) per customer_id by order_date
-------------------------------------
SELECT sale_id, customer_id, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM sales_data;

-------------------------------------
-- 17. Sales growth rate (growth_rate) month vs previous month
-------------------------------------
SELECT FORMAT(order_date, 'yyyy-MM') AS SaleMonth,
       SUM(total_amount) AS MonthlySales,
       LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) AS PrevMonthSales,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM'))) * 100.0 /
       NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')), 0) AS GrowthRate
FROM sales_data
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY SaleMonth;

-------------------------------------
-- 18. Identify customers whose total_amount is higher than their last order's total_amount
-------------------------------------
SELECT sale_id, customer_id, order_date, total_amount
FROM (
    SELECT sale_id, customer_id, order_date, total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS PrevTotal
    FROM sales_data
) t
WHERE total_amount > PrevTotal;

/* ============================
   HARD QUESTIONS
   ============================ */

-------------------------------------
-- 19. Products with prices above average product price
-------------------------------------
SELECT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-------------------------------------
-- 20. MyData: Sum val1 + val2 for each group (single SELECT)
-------------------------------------
SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
            THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
            ELSE NULL END AS Tot
FROM MyData;

-------------------------------------
-- 21. TheSumPuzzle: Sum cost and quantity by ID
-------------------------------------
SELECT ID,
       SUM(Cost) AS Cost,
       SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-------------------------------------
-- 22. Identify seat gaps (start and end of missing ranges)
-------------------------------------
WITH Numbered AS (
    SELECT SeatNumber,
           LAG(SeatNumber) OVER (ORDER BY SeatNumber) AS PrevSeat
    FROM Seats
),
Gaps AS (
    SELECT (PrevSeat + 1) AS GapStart, (SeatNumber - 1) AS GapEnd
    FROM Numbered
    WHERE SeatNumber - PrevSeat > 1
)
SELECT * FROM Gaps;
