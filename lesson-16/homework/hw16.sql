/* ============================
   Lesson 16 - CTEs & Derived Tables
   Solved in SQL Server (All Tasks)
   ============================ */

-------------------------------------
-- EASY TASKS
-------------------------------------

-- 1. Numbers table from 1 to 1000 using recursion
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 1000);

-- 2. Total sales per employee using derived table
SELECT e.EmployeeID, e.FirstName, e.LastName, dt.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID;

-- 3. Average salary of employees using a CTE
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT * FROM AvgSalary;

-- 4. Highest sales for each product using derived table
SELECT p.ProductName, dt.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID;

-- 5. Doubling numbers until less than 1,000,000
WITH DoubleNums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2 FROM DoubleNums WHERE n * 2 < 1000000
)
SELECT * FROM DoubleNums
OPTION (MAXRECURSION 100);

-- 6. Employees who made more than 5 sales using CTE
WITH EmpSales AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.FirstName, e.LastName
FROM EmpSales es
JOIN Employees e ON es.EmployeeID = e.EmployeeID
WHERE es.SaleCount > 5;

-- 7. Products with sales > $500 using CTE
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductName, ps.TotalSales
FROM ProductSales ps
JOIN Products p ON ps.ProductID = p.ProductID
WHERE ps.TotalSales > 500;

-- 8. Employees with salary above average salary
WITH AvgSal AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e, AvgSal
WHERE e.Salary > AvgSal.AvgSalary;

-------------------------------------
-- MEDIUM TASKS
-------------------------------------

-- 9. Top 5 employees by number of orders using derived table
SELECT TOP 5 e.FirstName, e.LastName, dt.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.OrderCount DESC;

-- 10. Sales per product category using derived table
SELECT p.CategoryID, dt.TotalSales
FROM Products p
JOIN (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID
GROUP BY p.CategoryID, dt.TotalSales;

-- 11. Factorial of each value in Numbers1 using recursion
WITH FactorialCTE AS (
    SELECT Number, 1 AS fact, Number AS n
    FROM Numbers1
    UNION ALL
    SELECT Number, fact * n, n - 1
    FROM FactorialCTE
    WHERE n > 1
)
SELECT Number, MAX(fact) AS Factorial
FROM FactorialCTE
GROUP BY Number;

-- 12. Split string into rows using recursion
WITH SplitCTE AS (
    SELECT Id, String, 1 AS pos, SUBSTRING(String,1,1) AS ch
    FROM Example
    UNION ALL
    SELECT Id, String, pos+1, SUBSTRING(String,pos+1,1)
    FROM SplitCTE
    WHERE pos+1 <= LEN(String)
)
SELECT Id, ch FROM SplitCTE
WHERE ch IS NOT NULL
OPTION (MAXRECURSION 1000);

-- 13. Sales difference between current and previous month
WITH MonthlySales AS (
    SELECT YEAR(SaleDate) AS Yr, MONTH(SaleDate) AS Mn, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
DiffCTE AS (
    SELECT Yr, Mn,
           TotalSales - LAG(TotalSales) OVER (ORDER BY Yr, Mn) AS SalesDiff
    FROM MonthlySales
)
SELECT * FROM DiffCTE;

-- 14. Employees with sales > 45000 in each quarter using derived table
SELECT e.FirstName, e.LastName, dt.Qtr, dt.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, DATEPART(QUARTER, SaleDate) AS Qtr, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) dt ON e.EmployeeID = dt.EmployeeID;

-------------------------------------
-- DIFFICULT TASKS
-------------------------------------

-- 15. Fibonacci numbers using recursion
WITH Fib (n, a, b) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n+1, b, a+b FROM Fib WHERE n < 20
)
SELECT n, a AS Fibonacci FROM Fib;

-- 16. Find string where all characters are same and length > 1
SELECT * FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(REPLACE(Vals, LEFT(Vals,1), '')) = 0;

-- 17. Numbers table showing gradual sequence (n=5 => 1,12,123,...)
WITH SeqCTE AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(50)) AS seq
    UNION ALL
    SELECT n+1, seq + CAST(n+1 AS VARCHAR(10))
    FROM SeqCTE WHERE n < 5
)
SELECT * FROM SeqCTE;

-- 18. Employees with most sales in last 6 months using derived table
SELECT TOP 1 e.FirstName, e.LastName, dt.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.TotalSales DESC;

-- 19. Remove duplicate integers and single digit ints from string column
SELECT PawanName,
       Pawan_slug_name,
       REPLACE(
         REPLACE(
           REPLACE(Pawan_slug_name,'111','1'),
           '4444','44'),
         '-3','') AS CleanedName
FROM RemoveDuplicateIntsFromNames;
