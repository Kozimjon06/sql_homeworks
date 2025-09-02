/* =========================
   🟢 EASY (10 puzzles)
   ========================= */

/* 1) Products × Suppliers — all combinations of product names and supplier names */
SELECT p.ProductName, s.SupplierName
FROM Products AS p
CROSS JOIN Suppliers AS s;

/* 2) Departments × Employees — all combinations */
SELECT d.DepartmentName, e.Name AS EmployeeName
FROM Departments AS d
CROSS JOIN Employees  AS e;

/* 3) Products × Suppliers — only where supplier actually supplies the product */
SELECT s.SupplierName, p.ProductName
FROM Products  AS p
JOIN Suppliers AS s ON s.SupplierID = p.SupplierID;

/* 4) Orders × Customers — customer names and their order IDs */
SELECT (c.FirstName + ' ' + c.LastName) AS CustomerName, o.OrderID
FROM Orders AS o
JOIN Customers AS c ON c.CustomerID = o.CustomerID;

/* 5) Students × Courses — all combinations */
SELECT st.Name AS StudentName, co.CourseName
FROM Students AS st
CROSS JOIN Courses  AS co;

/* 6) Products × Orders — product names and orders where product IDs match */
SELECT p.ProductName, o.OrderID, o.Quantity
FROM Orders   AS o
JOIN Products AS p ON p.ProductID = o.ProductID;

/* 7) Departments × Employees — employees whose DepartmentID matches */
SELECT d.DepartmentName, e.Name AS EmployeeName
FROM Employees  AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID;

/* 8) Students × Enrollments — student names and their enrolled course IDs */
SELECT st.Name AS StudentName, en.CourseID
FROM Enrollments AS en
JOIN Students    AS st ON st.StudentID = en.StudentID;

/* 9) Payments × Orders — all orders that have matching payments */
SELECT o.OrderID, pmt.PaymentID, pmt.Amount, pmt.PaymentDate
FROM Orders   AS o
JOIN Payments AS pmt ON pmt.OrderID = o.OrderID;

/* 10) Orders × Products — orders where product price > 100 */
SELECT o.OrderID, p.ProductName, p.Price
FROM Orders   AS o
JOIN Products AS p ON p.ProductID = o.ProductID
WHERE p.Price > 100;


/* =========================
   🟡 MEDIUM (10 puzzles)
   ========================= */

/* 11) Employees × Departments — mismatched employee-department combinations (IDs not equal) */
SELECT e.Name AS EmployeeName, e.DepartmentID AS EmployeeDeptID,
       d.DepartmentName, d.DepartmentID AS DeptID
FROM Employees AS e
CROSS JOIN Departments AS d
WHERE e.DepartmentID <> d.DepartmentID;

/* 12) Orders × Products — ordered quantity > stock quantity */
SELECT o.OrderID, p.ProductName, o.Quantity, p.StockQuantity
FROM Orders   AS o
JOIN Products AS p ON p.ProductID = o.ProductID
WHERE o.Quantity > p.StockQuantity;

/* 13) Customers × Sales — customer names and product IDs where sale amount >= 500 */
SELECT (c.FirstName + ' ' + c.LastName) AS CustomerName, s.ProductID, s.SaleAmount
FROM Sales     AS s
JOIN Customers AS c ON c.CustomerID = s.CustomerID
WHERE s.SaleAmount >= 500;

/* 14) Courses × Enrollments × Students — student names and course names they’re enrolled in */
SELECT st.Name AS StudentName, co.CourseName
FROM Enrollments AS en
JOIN Students    AS st ON st.StudentID = en.StudentID
JOIN Courses     AS co ON co.CourseID  = en.CourseID;

/* 15) Products × Suppliers — product & supplier where supplier name contains 'Tech' */
SELECT p.ProductName, s.SupplierName
FROM Products  AS p
JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
WHERE s.SupplierName LIKE '%Tech%';

/* 16) Orders × Payments — orders where payment amount < total amount */
SELECT o.OrderID, o.TotalAmount, pmt.PaymentID, pmt.Amount AS PaidAmount
FROM Orders   AS o
JOIN Payments AS pmt ON pmt.OrderID = o.OrderID
WHERE pmt.Amount < o.TotalAmount;

/* 17) Employees × Departments — department name for each employee (include employees without a valid department) */
SELECT e.EmployeeID, e.Name AS EmployeeName, e.DepartmentID, d.DepartmentName
FROM Employees  AS e
LEFT JOIN Departments AS d ON d.DepartmentID = e.DepartmentID;

/* 18) Products × Categories — products in categories 'Electronics' or 'Furniture' */
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products  AS p
JOIN Categories AS c ON c.CategoryID = p.Category
WHERE c.CategoryName IN ('Electronics','Furniture');

/* 19) Sales × Customers — all sales from customers who are from 'USA' */
SELECT s.SaleID, s.ProductID, s.SaleDate, s.SaleAmount,
       (c.FirstName + ' ' + c.LastName) AS CustomerName, c.Country
FROM Sales     AS s
JOIN Customers AS c ON c.CustomerID = s.CustomerID
WHERE c.Country = 'USA';

/* 20) Orders × Customers — orders by customers from 'Germany' with order total > 100 */
SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       (c.FirstName + ' ' + c.LastName) AS CustomerName, c.City, c.Country
FROM Orders    AS o
JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Germany'
  AND o.TotalAmount > 100;


/* =========================
   🔴 HARD (5 puzzles)
   ========================= */

/* 21) Employees — all pairs of employees from different departments */
SELECT e1.EmployeeID AS EmpID1, e1.Name AS EmpName1, e1.DepartmentID AS Dept1,
       e2.EmployeeID AS EmpID2, e2.Name AS EmpName2, e2.DepartmentID AS Dept2
FROM Employees AS e1
JOIN Employees AS e2
  ON e1.EmployeeID < e2.EmployeeID
 AND ISNULL(e1.DepartmentID, -1) <> ISNULL(e2.DepartmentID, -1);

/* 22) Payments × Orders × Products — payments where paid amount <> (Quantity × Product Price) */
SELECT pmt.PaymentID, pmt.OrderID, pmt.Amount AS PaidAmount,
       o.Quantity, pr.Price, (o.Quantity * pr.Price) AS ExpectedAmount
FROM Payments AS pmt
JOIN Orders   AS o  ON o.OrderID     = pmt.OrderID
JOIN Products AS pr ON pr.ProductID  = o.ProductID
WHERE pmt.Amount <> (o.Quantity * pr.Price);

/* 23) Students × Enrollments × Courses — students not enrolled in any course */
SELECT st.StudentID, st.Name AS StudentName
FROM Students AS st
LEFT JOIN Enrollments AS en ON en.StudentID = st.StudentID
WHERE en.StudentID IS NULL;

/* 24) Employees — managers of someone whose salary <= the person they manage */
SELECT DISTINCT m.EmployeeID AS ManagerID, m.Name AS ManagerName, m.Salary AS ManagerSalary,
       e.EmployeeID AS ReportID,  e.Name AS ReportName,  e.Salary AS ReportSalary
FROM Employees AS e
JOIN Employees AS m ON m.EmployeeID = e.ManagerID
WHERE ISNULL(m.Salary, 0) <= ISNULL(e.Salary, 0);

/* 25) Orders × Payments × Customers — customers who made an order with no recorded payment */
SELECT DISTINCT c.CustomerID, (c.FirstName + ' ' + c.LastName) AS CustomerName, o.O
