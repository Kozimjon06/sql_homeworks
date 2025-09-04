/* ================================
   🟢 EASY LEVEL (9 queries)
   ================================ */

/* 1) Employees with salary > 50000 + department names */
SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 50000;

/* 2) Customers + Orders placed in 2023 */
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

/* 3) All employees + department names (include no dept) */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID;

/* 4) Suppliers + products (include suppliers without products) */
SELECT s.SupplierName, p.ProductName
FROM Suppliers s
LEFT JOIN Products p ON p.SupplierID = s.SupplierID;

/* 5) Orders + Payments (include unmatched both sides) */
SELECT o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
FROM Orders o
FULL OUTER JOIN Payments p ON p.OrderID = o.OrderID;

/* 6) Employees + their managers */
SELECT e.Name AS EmployeeName, m.Name AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON m.EmployeeID = e.ManagerID;

/* 7) Students enrolled in 'Math 101' */
SELECT st.Name AS StudentName, c.CourseName
FROM Enrollments en
JOIN Students st ON st.StudentID = en.StudentID
JOIN Courses c ON c.CourseID = en.CourseID
WHERE c.CourseName = 'Math 101';

/* 8) Customers with orders having >3 items */
SELECT c.FirstName, c.LastName, o.Quantity
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.Quantity > 3;

/* 9) Employees in 'Human Resources' */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Human Resources';


/* ================================
   🟠 MEDIUM LEVEL (9 queries)
   ================================ */

/* 10) Departments with more than 5 employees */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
JOIN Employees e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 5;

/* 11) Products never sold */
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
WHERE s.SaleID IS NULL;

/* 12) Customers with at least one order */
SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 1;

/* 13) Only valid employee-department combos (no NULLs) */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID;

/* 14) Employee pairs with same manager */
SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID;

/* 15) Orders in 2022 + customer names */
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

/* 16) Sales dept employees with salary > 60000 */
SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 60000;

/* 17) Orders with payments */
SELECT o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
FROM Orders o
JOIN Payments p ON p.OrderID = o.OrderID;

/* 18) Products never ordered */
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON o.ProductID = p.ProductID
WHERE o.OrderID IS NULL;


/* ================================
   🔴 HARD LEVEL (9 queries)
   ================================ */

/* 19) Employees earning > avg salary in their dept */
SELECT e.Name AS EmployeeName, e.Salary
FROM Employees e
JOIN (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) sub ON sub.DepartmentID = e.DepartmentID
WHERE e.Salary > sub.AvgSalary;

/* 20) Orders before 2020 without payment */
SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON p.OrderID = o.OrderID
WHERE p.OrderID IS NULL AND o.OrderDate < '2020-01-01';

/* 21) Products without category */
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Categories c ON c.CategoryID = p.Category
WHERE c.CategoryID IS NULL;

/* 22) Employees under same manager & salary > 60000 */
SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID, e1.Salary
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID
  AND e1.Salary > 60000
  AND e2.Salary > 60000;

/* 23) Employees in departments starting with 'M' */
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

/* 24) Sales with amount > 500 + product names */
SELECT s.SaleID, p.ProductName, s.SaleAmount
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.SaleAmount > 500;

/* 25) Students NOT in 'Math 101' */
SELECT st.StudentID, st.Name AS StudentName
FROM Students st
WHERE st.StudentID NOT IN (
    SELECT en.StudentID
    FROM Enrollments en
    JOIN Courses c ON c.CourseID = en.CourseID
    WHERE c.CourseName = 'Math 101'
);

/* 26) Orders missing payment details */
SELECT o.OrderID, o.OrderDate, p.PaymentID
FROM Orders o
LEFT JOIN Payments p ON p.OrderID = o.OrderID
WHERE p.PaymentID IS NULL;

/* 27) Products in Electronics or Furniture */
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
JOIN Categories c ON c.CategoryID = p.Category
WHERE c.CategoryName IN ('Electronics','Furniture');
