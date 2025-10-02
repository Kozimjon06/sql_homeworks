/* ============================
   Lesson 21 - Window Functions
   ============================ */

-------------------------------------
-- 1. Assign a row number to each sale based on the SaleDate
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-------------------------------------
-- 2. Rank products based on total quantity sold (DENSE_RANK)
-------------------------------------
SELECT ProductName, SUM(Quantity) AS TotalQty,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankByQty
FROM ProductSales
GROUP BY ProductName;

-------------------------------------
-- 3. Top sale for each customer
-------------------------------------
SELECT SaleID, CustomerID, ProductName, SaleAmount
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) t
WHERE rn = 1;

-------------------------------------
-- 4. Each sale's amount with the next sale amount (by SaleDate)
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale
FROM ProductSales;

-------------------------------------
-- 5. Each sale's amount with the previous sale amount (by SaleDate)
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
FROM ProductSales;

-------------------------------------
-- 6. Sales amounts greater than the previous sale
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount
FROM (
    SELECT SaleID, SaleDate, SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE SaleAmount > PrevSale;

-------------------------------------
-- 7. Difference in sale amount from previous sale (per product)
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrev
FROM ProductSales;

-------------------------------------
-- 8. Compare current sale with next sale (percentage change)
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       ( (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount ) AS PctChangeNext
FROM ProductSales;

-------------------------------------
-- 9. Ratio of current sale to previous sale (per product)
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       CAST(SaleAmount AS FLOAT) / NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate), 0) AS RatioPrev
FROM ProductSales;

-------------------------------------
-- 10. Difference in sale amount from first sale of that product
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

-------------------------------------
-- 11. Sales continuously increasing per product
-------------------------------------
SELECT SaleID, ProductName, SaleDate, SaleAmount
FROM (
    SELECT SaleID, ProductName, SaleDate, SaleAmount,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE SaleAmount > PrevSale;

-------------------------------------
-- 12. Running total (closing balance) of sales
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales;

-------------------------------------
-- 13. Moving average of last 3 sales
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

-------------------------------------
-- 14. Difference between each sale and average sale amount
-------------------------------------
SELECT SaleID, SaleDate, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;


/* ============================
   Employees1 Tasks
   ============================ */

-------------------------------------
-- 15. Employees who have the same salary rank
-------------------------------------
SELECT EmployeeID, Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-------------------------------------
-- 16. Top 2 highest salaries in each department
-------------------------------------
SELECT EmployeeID, Name, Department, Salary
FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) t
WHERE rnk <= 2;

-------------------------------------
-- 17. Lowest-paid employee in each department
-------------------------------------
SELECT EmployeeID, Name, Department, Salary
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rn
    FROM Employees1
) t
WHERE rn = 1;

-------------------------------------
-- 18. Running total of salaries in each department
-------------------------------------
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Employees1;

-------------------------------------
-- 19. Total salary of each department (no GROUP BY)
-------------------------------------
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

-------------------------------------
-- 20. Average salary in each department (no GROUP BY)
-------------------------------------
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

-------------------------------------
-- 21. Difference between salary and department’s average
-------------------------------------
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

-------------------------------------
-- 22. Moving average salary over 3 employees (previous, current, next)
-------------------------------------
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

-------------------------------------
-- 23. Sum of salaries for the last 3 hired employees
-------------------------------------
SELECT SUM(Salary) AS SumLast3
FROM (
    SELECT Salary,
           ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) t
WHERE rn <= 3;
