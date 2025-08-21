-----------------------------------------------------------
-- ✅ EASY-LEVEL TASKS
-----------------------------------------------------------

-- 1. Select top 5 employees
SELECT TOP 5 * 
FROM Employees;

-- 2. Select distinct Category from Products
SELECT DISTINCT Category 
FROM Products;

-- 3. Products with Price > 100
SELECT * 
FROM Products 
WHERE Price > 100;

-- 4. Customers whose FirstName starts with 'A'
SELECT * 
FROM Customers 
WHERE FirstName LIKE 'A%';

-- 5. Order Products by Price ASC
SELECT * 
FROM Products 
ORDER BY Price ASC;

-- 6. Employees with Salary >= 60000 and Department = 'HR'
SELECT * 
FROM Employees 
WHERE Salary >= 60000 
  AND DepartmentName = 'HR';

-- 7. Replace NULL email with default text
SELECT EmployeeID, ISNULL(Email, 'noemail@example.com') AS Email 
FROM Employees;

-- 8. Products priced between 50 and 100
SELECT * 
FROM Products 
WHERE Price BETWEEN 50 AND 100;

-- 9. Select distinct Category and ProductName
SELECT DISTINCT Category, ProductName 
FROM Products;

-- 10. Same as above but ordered by ProductName DESC
SELECT DISTINCT Category, ProductName 
FROM Products
ORDER BY ProductName DESC;


-----------------------------------------------------------
-- 🟠 MEDIUM-LEVEL TASKS
-----------------------------------------------------------

-- 1. Top 10 products ordered by Price DESC
SELECT TOP 10 * 
FROM Products 
ORDER BY Price DESC;

-- 2. Use COALESCE to return First non-null from FirstName or LastName
SELECT EmployeeID, COALESCE(FirstName, LastName) AS FirstNonNull 
FROM Employees;

-- 3. Distinct Category and Price from Products
SELECT DISTINCT Category, Price 
FROM Products;

-- 4. Employees with Age between 30 and 40 OR Department = 'Marketing'
SELECT * 
FROM Employees 
WHERE (Age BETWEEN 30 AND 40) 
   OR DepartmentName = 'Marketing';

-- 5. OFFSET-FETCH rows 11–20 ordered by Salary DESC
SELECT * 
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 6. Products with Price <= 1000 and Stock > 50 sorted by Stock ASC
SELECT * 
FROM Products 
WHERE Price <= 1000 
  AND StockQuantity > 50
ORDER BY StockQuantity ASC;

-- 7. Products containing letter 'e' in ProductName
SELECT * 
FROM Products 
WHERE ProductName LIKE '%e%';

-- 8. Employees who work in HR, IT, or Finance
SELECT * 
FROM Employees 
WHERE DepartmentName IN ('HR', 'IT', 'Finance');

-- 9. Customers ordered by City ASC and PostalCode DESC
SELECT * 
FROM Customers 
ORDER BY City ASC, PostalCode DESC;


-----------------------------------------------------------
-- 🔴 HARD-LEVEL TASKS
-----------------------------------------------------------

-- 1. Top 5 products with highest sales
SELECT TOP 5 P.ProductName, SUM(S.SaleAmount) AS TotalSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSales DESC;

-- 2. Combine FirstName and LastName into FullName
SELECT EmployeeID, 
       COALESCE(FirstName,'') + ' ' + COALESCE(LastName,'') AS FullName
FROM Employees;

-- 3. Distinct Category, ProductName, Price > 50
SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;

-- 4. Products priced less than 10% of avg price
SELECT * 
FROM Products 
WHERE Price < (SELECT AVG(Price)*0.1 FROM Products);

-- 5. Employees Age < 30 and in HR or IT
SELECT * 
FROM Employees 
WHERE Age < 30 
  AND DepartmentName IN ('HR', 'IT');

-- 6. Customers whose Email contains '@gmail.com'
SELECT * 
FROM Customers 
WHERE Email LIKE '%@gmail.com%';

-- 7. Employees whose salary > ALL employees in Sales
SELECT * 
FROM Employees 
WHERE Salary > ALL (
    SELECT Salary 
    FROM Employees 
    WHERE DepartmentName = 'Sales'
);

-- 8. Orders in last 180 days
SELECT * 
FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE);
