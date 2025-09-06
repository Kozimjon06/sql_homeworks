/* ================================
   🟢 EASY LEVEL (7 queries)
   ================================ */

/* 1) Orders placed after 2022 + customer names */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) > 2022;

/* 2) Employees in Sales or Marketing */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');

/* 3) Max salary per department */
SELECT d.DepartmentName, MAX(e.Salary) AS MaxSalary
FROM Departments d
JOIN Employees e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

/* 4) USA customers with orders in 2023 */
SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'
  AND YEAR(o.OrderDate) = 2023;

/* 5) Total orders per customer */
SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName;

/* 6) Products supplied by Gadget Supplies or Clothing Mart */
SELECT p.ProductName, s.SupplierName
FROM Products p
JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

/* 7) Each customer's most recent order (include no orders) */
SELECT c.CustomerName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName;


/* ================================
   🟠 MEDIUM LEVEL (6 queries)
   ================================ */

/* 8) Customers with orders > 500 */
SELECT c.CustomerName, o.TotalAmount AS OrderTotal
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;

/* 9) Product sales in 2022 OR sale > 400 */
SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2022
   OR s.SaleAmount > 400;

/* 10) Products + total sales amount */
SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Products p
JOIN Sales s ON s.ProductID = p.ProductID
GROUP BY p.ProductName;

/* 11) HR employees with salary > 60000 */
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'HR'
  AND e.Salary > 60000;

/* 12) Products sold in 2023 with stock > 100 */
SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Products p
JOIN Sales s ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2023
  AND p.StockQuantity > 100;

/* 13) Sales dept employees OR hired after 2020 */
SELECT e.Name AS EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Sales'
   OR YEAR(e.HireDate) > 2020;


/* ================================
   🔴 HARD LEVEL (7 queries)
   ================================ */

/* 14) USA orders with address starting with 4 digits */
SELECT c.CustomerName, o.OrderID, c.Address, o.OrderDate
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'
  AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';

/* 15) Electronics sales OR sale > 350 */
SELECT p.ProductName, p.Category, s.SaleAmount
FROM Products p
JOIN Sales s ON s.ProductID = p.ProductID
WHERE p.Category = 'Electronics'
   OR s.SaleAmount > 350;

/* 16) Product count per category */
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON p.Category = c.CategoryID
GROUP BY c.CategoryName;

/* 17) Los Angeles customers with orders > 300 */
SELECT c.CustomerName, c.City, o.OrderID, o.Amount
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE c.City = 'Los Angeles'
  AND o.Amount > 300;

/* 18) HR or Finance employees OR names with ≥4 vowels */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('HR','Finance')
   OR (
       LEN(e.Name)
       - LEN(REPLACE(LOWER(e.Name), 'a', ''))
       - LEN(REPLACE(LOWER(e.Name), 'e', ''))
       - LEN(REPLACE(LOWER(e.Name), 'i', ''))
       - LEN(REPLACE(LOWER(e.Name), 'o', ''))
       - LEN(REPLACE(LOWER(e.Name), 'u', ''))
     ) >= 4;

/* 19) Sales/Marketing employees with salary > 60000 */
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('Sales','Marketing')
  AND e.Salary > 60000;
