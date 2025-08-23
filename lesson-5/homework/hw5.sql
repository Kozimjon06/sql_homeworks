--------------------------------------------------
-- EASY LEVEL TASKS
--------------------------------------------------

-- 1. Alias column
SELECT ProductName AS Name
FROM Products;

-- 2. Alias table
SELECT *
FROM Customers AS Client;

-- 3. UNION of Product Names
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 4. INTERSECT of Products and Products_Discounted
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;

-- 5. DISTINCT customer names + country
SELECT DISTINCT FirstName, LastName, Country
FROM Customers;

-- 6. CASE for High/Low price
SELECT ProductName,
       Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;

-- 7. IIF for stock quantity
SELECT ProductName,
       StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS StockStatus
FROM Products_Discounted;

--------------------------------------------------
-- MEDIUM LEVEL TASKS
--------------------------------------------------

-- 1. UNION of Product Names
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 2. Difference (EXCEPT)
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;

-- 3. IIF for Expensive/Affordable
SELECT ProductName,
       Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

-- 4. Employees with Age < 25 or Salary > 60000
SELECT *
FROM Employees
WHERE Age < 25 OR Salary > 60000;

-- 5. Update salary (10% increase) for HR or EmployeeID=5
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentName = 'HR' OR EmployeeID = 5;

--------------------------------------------------
-- HARD LEVEL TASKS
--------------------------------------------------

-- 1. CASE for SaleAmount tiers
SELECT SaleID,
       SaleAmount,
       CASE 
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS SaleCategory
FROM Sales;

-- 2. Customers who placed orders but not in Sales
SELECT CustomerID
FROM Orders
EXCEPT
SELECT CustomerID
FROM Sales;

-- 3. CASE for discount percentage in Orders
SELECT CustomerID,
       Quantity,
       CASE 
           WHEN Quantity = 1 THEN '3%'
           WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
           ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
