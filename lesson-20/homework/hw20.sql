/* ============================
   Lesson 20 - Practice
   ============================ */

-------------------------------------
-- 1. Customers with at least one purchase in March 2024 using EXISTS
-------------------------------------
SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales x
    WHERE x.CustomerName = s.CustomerName
      AND MONTH(x.SaleDate) = 3
      AND YEAR(x.SaleDate) = 2024
);

-------------------------------------
-- 2. Product with highest total sales revenue using subquery
-------------------------------------
SELECT TOP 1 Product, SUM(Quantity * Price) AS Revenue
FROM #Sales
GROUP BY Product
ORDER BY Revenue DESC;

-------------------------------------
-- 3. Second highest sale amount using subquery
-------------------------------------
SELECT MAX(TotalSale) AS SecondHighestSale
FROM (
    SELECT Quantity * Price AS TotalSale
    FROM #Sales
) t
WHERE TotalSale < (
    SELECT MAX(Quantity * Price) FROM #Sales
);

-------------------------------------
-- 4. Total quantity sold per month using subquery
-------------------------------------
SELECT SaleMonth, SUM(Quantity) AS TotalQuantity
FROM (
    SELECT MONTH(SaleDate) AS SaleMonth, Quantity
    FROM #Sales
) t
GROUP BY SaleMonth;

-------------------------------------
-- 5. Customers who bought same products as another customer using EXISTS
-------------------------------------
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

-------------------------------------
-- 6. Fruits table pivot to count each fruit per person
-------------------------------------
SELECT Name,
       SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-------------------------------------
-- 7. Older people with younger ones (family hierarchy)
-------------------------------------
WITH FamilyCTE AS (
    SELECT ParentId, ChildID FROM Family
    UNION ALL
    SELECT f.ParentId, c.ChildID
    FROM FamilyCTE f
    JOIN Family c ON f.ChildID = c.ParentId
)
SELECT * FROM FamilyCTE;

-------------------------------------
-- 8. Customers with CA delivery, return their TX orders
-------------------------------------
SELECT o.CustomerID, o.OrderID, o.Amount
FROM #Orders o
WHERE o.DeliveryState = 'TX'
AND EXISTS (
    SELECT 1 FROM #Orders x
    WHERE x.CustomerID = o.CustomerID
      AND x.DeliveryState = 'CA'
);

-------------------------------------
-- 9. Insert missing names from address column into residents
-------------------------------------
UPDATE #residents
SET fullname = PARSENAME(REPLACE(REPLACE(address,'name=',''), ' ', '.'), 3)
WHERE fullname IS NULL OR fullname NOT LIKE '%';

-------------------------------------
-- 10. Cheapest and most expensive route from Tashkent to Khorezm
-------------------------------------
WITH Paths AS (
    SELECT DepartureCity, ArrivalCity, CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(200)) AS Route, Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    UNION ALL
    SELECT p.DepartureCity, r.ArrivalCity, p.Route + ' - ' + r.ArrivalCity, p.Cost + r.Cost
    FROM Paths p
    JOIN #Routes r ON p.ArrivalCity = r.DepartureCity
)
SELECT Route, Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm';

-------------------------------------
-- 11. Rank products by insertion order
-------------------------------------
SELECT ID, Vals,
       DENSE_RANK() OVER (ORDER BY ID) AS RankOrder
FROM #RankingPuzzle;

-------------------------------------
-- 12. Employees whose sales > avg sales in department
-------------------------------------
SELECT e.EmployeeName, e.Department, e.SalesAmount
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales x
    WHERE x.Department = e.Department
);

-------------------------------------
-- 13. Employees with highest sales in any given month using EXISTS
-------------------------------------
SELECT DISTINCT e.EmployeeName, e.SalesMonth, e.SalesAmount
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales x
    WHERE x.SalesMonth = e.SalesMonth
      AND x.SalesYear = e.SalesYear
    HAVING MAX(x.SalesAmount) = e.SalesAmount
);

-------------------------------------
-- 14. Employees who made sales in every month using NOT EXISTS
-------------------------------------
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT m.SalesMonth
    FROM (SELECT DISTINCT SalesMonth FROM #EmployeeSales) m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales x
        WHERE x.EmployeeName = e.EmployeeName
          AND x.SalesMonth = m.SalesMonth
    )
);

-------------------------------------
-- 15. Products more expensive than avg price
-------------------------------------
SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-------------------------------------
-- 16. Products with stock < highest stock
-------------------------------------
SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

-------------------------------------
-- 17. Products in same category as Laptop
-------------------------------------
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop');

-------------------------------------
-- 18. Products with price > lowest price in Electronics
-------------------------------------
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price) FROM Products WHERE Category = 'Electronics'
);

-------------------------------------
-- 19. Products priced higher than avg of their category
-------------------------------------
SELECT p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(x.Price)
    FROM Products x
    WHERE x.Category = p.Category
);

-------------------------------------
-- 20. Products ordered at least once
-------------------------------------
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-------------------------------------
-- 21. Products ordered more than avg quantity
-------------------------------------
SELECT p.Name, SUM(o.Quantity) AS TotalQty
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders);

-------------------------------------
-- 22. Products never ordered
-------------------------------------
SELECT Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
);

-------------------------------------
-- 23. Product with highest total quantity ordered
-------------------------------------
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQty
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
