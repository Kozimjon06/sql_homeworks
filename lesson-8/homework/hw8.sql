------------------------------------------------------------
-- EASY LEVEL TASKS
------------------------------------------------------------
-- 1. Total number of products in each category
SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;

-- 2. Average price of products in 'Electronics'
SELECT AVG(Price) AS AvgPriceElectronics
FROM Products
WHERE Category = 'Electronics';

-- 3. Customers from cities starting with 'L'
SELECT *
FROM Customers
WHERE City LIKE 'L%';

-- 4. Product names ending with 'er'
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

-- 5. Customers from countries ending with 'A'
SELECT *
FROM Customers
WHERE Country LIKE '%A';

-- 6. Highest price among all products
SELECT MAX(Price) AS HighestPrice
FROM Products;

-- 7. Stock labeling
SELECT ProductName,
       CASE WHEN StockQuantity < 30 THEN 'Low Stock'
            ELSE 'Sufficient' END AS StockStatus
FROM Products;

-- 8. Total number of customers in each country
SELECT Country, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country;

-- 9. Min and Max quantity ordered
SELECT MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders;

------------------------------------------------------------
-- MEDIUM LEVEL TASKS
------------------------------------------------------------
-- 1. Customers who ordered in Jan 2023 but no invoices
SELECT DISTINCT o.CustomerID
FROM Orders o
WHERE YEAR(o.OrderDate)=2023 AND MONTH(o.OrderDate)=1
  AND o.CustomerID NOT IN (
    SELECT CustomerID FROM Invoices WHERE YEAR(InvoiceDate)=2023 AND MONTH(InvoiceDate)=1
);

-- 2. Combine product names with duplicates (UNION ALL)
SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

-- 3. Combine product names without duplicates (UNION)
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 4. Average order amount by year
SELECT YEAR(OrderDate) AS OrderYear, AVG(TotalAmount) AS AvgOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate);

-- 5. Group products by price
SELECT ProductName,
       CASE WHEN Price < 100 THEN 'Low'
            WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
            ELSE 'High' END AS PriceGroup
FROM Products;

-- 6. Pivot year into columns → copy into Population_Each_Year
SELECT district_name,
       [2012],[2013]
INTO Population_Each_Year
FROM (
  SELECT district_name, year, population FROM City_Population
) AS src
PIVOT (
  SUM(population) FOR year IN ([2012],[2013])
) AS p;

-- 7. Total sales per product
SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 8. Products containing 'oo'
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- 9. Pivot city into columns → copy into Population_Each_City
SELECT year,
       [Bektemir],[Chilonzor],[Yakkasaroy]
INTO Population_Each_City
FROM (
  SELECT district_name, year, population FROM City_Population
) AS src
PIVOT (
  SUM(population) FOR district_name IN ([Bektemir],[Chilonzor],[Yakkasaroy])
) AS p;

------------------------------------------------------------
-- HARD LEVEL TASKS
------------------------------------------------------------
-- 1. Top 3 customers by invoice amount
SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 2. Transform Population_Each_Year back to original format
SELECT district_name, '2012' AS Year, [2012] AS Population
FROM Population_Each_Year
UNION ALL
SELECT district_name, '2013', [2013]
FROM Population_Each_Year;

-- 3. Product names and number of times sold
SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

-- 4. Transform Population_Each_City back to original format
SELECT 'Bektemir' AS City, year, [Bektemir] AS Population
FROM Population_Each_City
UNION ALL
SELECT 'Chilonzor', year, [Chilonzor]
FROM Population_Each_City
UNION ALL
SELECT 'Yakkasaroy', year, [Yakkasaroy]
FROM Population_Each_City;
