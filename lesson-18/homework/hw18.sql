----------------------------------------------------------
-- Setup: Base Tables (Products, Sales)
----------------------------------------------------------
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

----------------------------------------------------------
-- Task 1: Temporary table MonthlySales (current month)
----------------------------------------------------------
DROP TABLE IF EXISTS #MonthlySales;

SELECT s.ProductID,
       SUM(s.Quantity) AS TotalQuantity,
       SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(SaleDate) = YEAR(GETDATE())
  AND MONTH(SaleDate) = MONTH(GETDATE())
GROUP BY s.ProductID;

SELECT * FROM #MonthlySales;

----------------------------------------------------------
-- Task 2: View vw_ProductSalesSummary
----------------------------------------------------------
DROP VIEW IF EXISTS vw_ProductSalesSummary;

CREATE VIEW vw_ProductSalesSummary AS
SELECT p.ProductID, p.ProductName, p.Category,
       ISNULL(SUM(s.Quantity),0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;

SELECT * FROM vw_ProductSalesSummary;

----------------------------------------------------------
-- Task 3: Function fn_GetTotalRevenueForProduct
----------------------------------------------------------
DROP FUNCTION IF EXISTS fn_GetTotalRevenueForProduct;
GO
CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);
    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;
    RETURN ISNULL(@Revenue,0);
END;
GO

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS RevenueForProduct1;

----------------------------------------------------------
-- Task 4: Function fn_GetSalesByCategory
----------------------------------------------------------
DROP FUNCTION IF EXISTS fn_GetSalesByCategory;
GO
CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT p.ProductName,
           SUM(s.Quantity) AS TotalQuantity,
           SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
GO

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');

----------------------------------------------------------
-- Task 5: Function fn_IsPrime
----------------------------------------------------------
DROP FUNCTION IF EXISTS fn_IsPrime;
GO
CREATE FUNCTION fn_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    IF @Number <= 1 RETURN 'No';
    DECLARE @i INT = 2;
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0 RETURN 'No';
        SET @i += 1;
    END
    RETURN 'Yes';
END;
GO

SELECT dbo.fn_IsPrime(7) AS IsPrime7, dbo.fn_IsPrime(91) AS IsPrime91;

----------------------------------------------------------
-- Task 6: Function fn_GetNumbersBetween
----------------------------------------------------------
DROP FUNCTION IF EXISTS fn_GetNumbersBetween;
GO
CREATE FUNCTION fn_GetNumbersBetween(@Start INT, @End INT)
RETURNS @Result TABLE(Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Result VALUES(@i);
        SET @i += 1;
    END
    RETURN;
END;
GO

SELECT * FROM dbo.fn_GetNumbersBetween(5,10);

----------------------------------------------------------
-- Task 7: Nth Highest Salary
----------------------------------------------------------
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(id INT, salary INT);
INSERT INTO Employee VALUES (1,100),(2,200),(3,300);

DECLARE @N INT = 2;

SELECT CASE WHEN COUNT(DISTINCT salary) < @N THEN NULL
            ELSE (SELECT DISTINCT salary
                  FROM Employee
                  ORDER BY salary DESC
                  OFFSET (@N-1) ROWS FETCH NEXT 1 ROWS ONLY)
       END AS HighestNSalary;

----------------------------------------------------------
-- Task 8: Person with most friends
----------------------------------------------------------
DROP TABLE IF EXISTS RequestAccepted;
CREATE TABLE RequestAccepted(requester_id INT, accepter_id INT, accept_date DATE);

INSERT INTO RequestAccepted VALUES
(1,2,'2016-06-03'),
(1,3,'2016-06-08'),
(2,3,'2016-06-08'),
(3,4,'2016-06-09');

WITH Friends AS (
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
    UNION ALL
    SELECT accepter_id, requester_id FROM RequestAccepted
)
SELECT TOP 1 id, COUNT(friend) AS num
FROM Friends
GROUP BY id
ORDER BY num DESC;

----------------------------------------------------------
-- Task 9: View vw_CustomerOrderSummary
----------------------------------------------------------
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO Customers VALUES
(1,'Alice Smith','New York'),
(2,'Bob Jones','Chicago'),
(3,'Carol White','Los Angeles');

INSERT INTO Orders VALUES
(101,1,'2024-12-10',120.00),
(102,1,'2024-12-20',200.00),
(103,1,'2024-12-30',220.00),
(104,2,'2025-01-12',120.00),
(105,2,'2025-01-20',180.00);

DROP VIEW IF EXISTS vw_CustomerOrderSummary;
GO
CREATE VIEW vw_CustomerOrderSummary AS
SELECT c.customer_id, c.name,
       COUNT(o.order_id) AS total_orders,
       ISNULL(SUM(o.amount),0) AS total_amount,
       MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
GO

SELECT * FROM vw_CustomerOrderSummary;

----------------------------------------------------------
-- Task 10: Fill missing workflow gaps
----------------------------------------------------------
DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps (
    RowNumber   INTEGER PRIMARY KEY,
    TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),
(10,'Charlie'),(11,NULL),(12,NULL);

WITH cte AS (
    SELECT RowNumber, TestCase,
           MAX(TestCase) OVER (ORDER BY RowNumber ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Workflow
    FROM Gaps
)
SELECT RowNumber, Workflow FROM cte;
