------------------------------------------------------------
-- 🟢 EASY LEVEL TASKS
------------------------------------------------------------

-- Task 1: Minimum price of a product
SELECT MIN(Price) AS MinPrice
FROM Products;

-- Task 2: Maximum salary
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

-- Task 3: Count rows in Customers
SELECT COUNT(*) AS CustomerCount
FROM Customers;

-- Task 4: Count unique product categories
SELECT COUNT(DISTINCT Category) AS UniqueCategories
FROM Products;

-- Task 5: Total sales amount for product id 7
SELECT SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE ProductID = 7;

-- Task 6: Average age of employees
SELECT AVG(Age) AS AvgAge
FROM Employees;

-- Task 7: Count employees in each department
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- Task 8: Min and Max price of products grouped by Category
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- Task 9: Total sales per Customer
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

-- Task 10: Departments having more than 5 employees
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;

------------------------------------------------------------
-- 🟠 MEDIUM LEVEL TASKS
------------------------------------------------------------

-- Task 11: Total and average sales per product category
SELECT p.Category, SUM(s.SaleAmount) AS TotalSales, AVG(s.SaleAmount) AS AvgSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.Category;

-- Task 12: Count employees from Department HR
SELECT COUNT(*) AS HREmployees
FROM Employees
WHERE DepartmentName = 'HR';

-- Task 13: Highest and lowest Salary by department
SELECT DepartmentName, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;

-- Task 14: Average salary per Department
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName;

-- Task 15: AVG salary and COUNT of employees per department
SELECT DepartmentName, AVG(Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- Task 16: Product categories with average price > 400
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- Task 17: Total sales per year
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

-- Task 18: Customers who placed at least 3 orders
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- Task 19: Departments with average salary > 60000
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;

------------------------------------------------------------
-- 🔴 HARD LEVEL TASKS
------------------------------------------------------------

-- Task 20: Avg price per category, filter > 150
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

-- Task 21: Total sales per Customer, filter > 1500
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

-- Task 22: Total & Avg salary per Department, filter avg > 65000
SELECT DepartmentName, SUM(Salary) AS TotalSalary, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- Task 23: Total amount for orders freight > 50 per customer with least purchases
-- (tsql2012.sales.orders with Freight col required)
-- Example structure:
-- SELECT CustomerID, SUM(Freight) AS TotalFreight, MIN(Freight) AS LeastFreight
-- FROM TSQL2012.Sales.Orders
-- WHERE Freight > 50
-- GROUP BY CustomerID;

-- Task 24: Total sales & unique products sold per month-year, filter months with >= 2 products
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth,
       SUM(TotalAmount) AS TotalSales, COUNT(DISTINCT ProductID) AS UniqueProducts
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2;

-- Task 25: Min and Max order quantity per Year
SELECT YEAR(OrderDate) AS OrderYear,
       MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders
GROUP BY YEAR(OrderDate);
