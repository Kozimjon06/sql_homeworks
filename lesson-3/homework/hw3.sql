/* ================================
   EASY LEVEL TASKS
   ================================ */

-- 1. Purpose of BULK INSERT
-- BULK INSERT is used to quickly load large amounts of data from external files into a SQL Server table.

-- 2. File formats that can be imported:
-- CSV, TXT, XML, JSON

-- 3. Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4. Insert three records
INSERT INTO Products (ProductID, ProductName, Price) VALUES (1, 'Laptop', 800.50);
INSERT INTO Products (ProductID, ProductName, Price) VALUES (2, 'Mouse', 20.00);
INSERT INTO Products (ProductID, ProductName, Price) VALUES (3, 'Keyboard', 45.75);

-- 5. Difference between NULL and NOT NULL
-- NULL = column can have missing value, NOT NULL = must always have a value

-- 6. Add UNIQUE constraint to ProductName
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- 7. Write a comment
-- This query selects all rows from Products
SELECT * FROM Products;

-- 8. Add CategoryID column
ALTER TABLE Products
ADD CategoryID INT;

-- 9. Create Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 10. Purpose of IDENTITY
-- IDENTITY automatically generates sequential values for a column.


/* ================================
    MEDIUM LEVEL TASKS
   ================================ */

-- 1. Use BULK INSERT to import data into Products
-- (Assumes file exists at given path)
BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- 2. Create FOREIGN KEY from Products to Categories
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

-- 3. Difference between PRIMARY KEY and UNIQUE KEY
-- PRIMARY KEY = unique + not null, only one per table
-- UNIQUE KEY = ensures uniqueness, can allow one NULL, multiple UNIQUE allowed

-- 4. Add CHECK constraint on Price
ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);

-- 5. Add Stock column (NOT NULL, default 0)
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

-- 6. Replace NULL values in Price with 0
SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

-- 7. Purpose of FOREIGN KEY
-- Ensures referential integrity between two tables (child references parent).


/* ================================
   HARD LEVEL TASKS
   ================================ */

-- 1. Create Customers table with CHECK constraint
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT CHECK (Age >= 18)
);

-- 2. Create table with IDENTITY (start 100, increment 10)
CREATE TABLE Orders (
    OrderID INT IDENTITY(100, 10) PRIMARY KEY,
    OrderDate DATETIME
);

-- 3. Create composite PRIMARY KEY in OrderDetails
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

-- 4. COALESCE vs ISNULL
-- ISNULL(expr, value) → replaces NULL with value (2 arguments only).
-- COALESCE(expr1, expr2, expr3, ...) → returns first non-NULL value from list.

-- 5. Create Employees table with PRIMARY KEY and UNIQUE
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- 6. FOREIGN KEY with ON DELETE/UPDATE CASCADE
ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE;
