/* ================================
   PUZZLE 1: Month with zero prefix
   ================================ */
SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

/* ================================
   PUZZLE 2: SUM of MAX(vals) per Id,rID
   ================================ */
SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) AS SubQ
GROUP BY rID;

/* ================================
   PUZZLE 3: Strings 6–10 chars
   ================================ */
SELECT 
    Id,
    Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

/* ================================
   PUZZLE 4: Max per ID with Item
   ================================ */
SELECT 
    t.ID,
    t.Item,
    t.Vals
FROM TestMaximum t
WHERE t.Vals = (
    SELECT MAX(Vals)
    FROM TestMaximum m
    WHERE m.ID = t.ID
)
ORDER BY t.ID;

/* ================================
   PUZZLE 5: Sum of max per Id, DetailedNumber
   ================================ */
SELECT 
    Id,
    SUM(MaxVal) AS SumOfMax
FROM (
    SELECT 
        Id,
        DetailedNumber,
        MAX(Vals) AS MaxVal
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS SubQ
GROUP BY Id;

/* ================================
   PUZZLE 6: a–b difference or blank
   ================================ */
SELECT 
    Id,
    a,
    b,
    CASE 
        WHEN a - b = 0 THEN ''
        ELSE CAST(a - b AS VARCHAR(20))
    END AS OUTPUT
FROM TheZeroPuzzle;

/* ============================================
   SALES, CUSTOMERS, PRODUCTS ANALYTICS SECTION
   ============================================ */

/* 1️⃣ Total revenue generated from all sales */
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

/* 2️⃣ Average unit price of products */
SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

/* 3️⃣ Number of sales transactions */
SELECT COUNT(*) AS TotalTransactions
FROM Sales;

/* 4️⃣ Highest number of units sold in a single transaction */
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

/* 5️⃣ Products sold in each category */
SELECT Category, COUNT(DISTINCT Product) AS TotalProductsSold
FROM Sales
GROUP BY Category;

/* 6️⃣ Total revenue for each region */
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

/* 7️⃣ Product generating highest total revenue */
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

/* 8️⃣ Running total of revenue ordered by sale date */
SELECT 
    SaleDate,
    SUM(QuantitySold * UnitPrice) AS DailyRevenue,
    SUM(SUM(QuantitySold * UnitPrice)) OVER (ORDER BY SaleDate) AS RunningTotal
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

/* 9️⃣ Category contribution to total sales revenue */
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(100.0 * SUM(QuantitySold * UnitPrice) / 
        (SELECT SUM(QuantitySold * UnitPrice) FROM Sales), 2) AS PercentOfTotal
FROM Sales
GROUP BY Category;

/* 🔟 Show all sales with corresponding customer names */
SELECT 
    s.SaleID,
    s.Product,
    s.Category,
    s.QuantitySold,
    s.UnitPrice,
    s.Region,
    c.CustomerName
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID;

/* 11️⃣ Customers with no purchases */
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.CustomerID IS NULL;

/* 12️⃣ Total revenue per customer */
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

/* 13️⃣ Customer with highest total revenue */
SELECT TOP 1
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

/* 14️⃣ Total sales per customer */
SELECT 
    c.CustomerName,
    COUNT(s.SaleID) AS TotalSales
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerName;

/* 15️⃣ Products sold at least once */
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

/* 16️⃣ Most expensive product */
SELECT TOP 1 ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

/* 17️⃣ Products priced above average in their category */
SELECT 
    p.ProductName,
    p.Category,
    p.SellingPrice
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(p2.SellingPrice)
    FROM Products p2
    WHERE p2.Category = p.Category
);
