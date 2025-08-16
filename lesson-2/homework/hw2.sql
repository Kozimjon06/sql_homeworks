/* ------------------- BASIC LEVEL TASKS ------------------- */

-- 1. Create Employees table
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

-- 2. Insert records using different INSERT approaches
-- Single row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice', 6000.00);

-- Another single row insert (without column names - assumes order)
INSERT INTO Employees
VALUES (2, 'Bob', 5000.00);

-- Multiple row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(3, 'Charlie', 4500.00),
(4, 'David', 5500.00);

-- 3. Update Salary of employee with EmpID = 1
UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;

-- 4. Delete record where EmpID = 2
DELETE FROM Employees
WHERE EmpID = 2;

-- 5. Difference between DELETE, TRUNCATE, DROP
/*
   DELETE   -> Removes specific rows using WHERE, can be rolled back (transaction safe).
   TRUNCATE -> Removes ALL rows, faster than DELETE, cannot use WHERE, minimal logging.
   DROP     -> Removes the entire table structure along with its data.
*/

-- 6. Modify Name column to VARCHAR(100)
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- 7. Add Department column
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- 8. Change Salary column type to FLOAT
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

-- 9. Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- 10. Remove all records from Employees table but keep structure
TRUNCATE TABLE Employees;


/* ------------------- INTERMEDIATE LEVEL TASKS ------------------- */

-- 1. Insert 5 records into Departments using INSERT INTO SELECT
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'HR' UNION ALL
SELECT 2, 'Finance' UNION ALL
SELECT 3, 'IT' UNION ALL
SELECT 4, 'Sales' UNION ALL
SELECT 5, 'Management';

-- 2. Update Department of employees where Salary > 5000
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

-- 3. Remove all employees but keep structure
TRUNCATE TABLE Employees;

-- 4. Drop Department column
ALTER TABLE Employees
DROP COLUMN Department;

-- 5. Rename Employees table to StaffMembers
EXEC sp_rename 'Employees', 'StaffMembers';

-- 6. Completely remove Departments table
DROP TABLE Departments;


/* ------------------- ADVANCED LEVEL TASKS ------------------- */

-- 1. Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Description VARCHAR(255)
);

-- 2. Add CHECK constraint to ensure Price > 0
ALTER TABLE Products
ADD CONSTRAINT chk_price CHECK (Price > 0);

-- 3. Add StockQuantity with default 50
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

-- 4. Rename Category to ProductCategory
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

-- 5. Insert 5 records into Products
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES
(1, 'Laptop', 'Electronics', 1000.00, '15 inch laptop'),
(2, 'Phone', 'Electronics', 700.00, 'Smartphone with 5G'),
(3, 'Table', 'Furniture', 150.00, 'Wooden dining table'),
(4, 'Chair', 'Furniture', 80.00, 'Office chair'),
(5, 'Headphones', 'Electronics', 120.00, 'Noise-cancelling headphones');

-- 6. Create backup using SELECT INTO
SELECT *
INTO Products_Backup
FROM Products;

-- 7. Rename Products to Inventory
EXEC sp_rename 'Products', 'Inventory';

-- 8. Change Price data type to FLOAT
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

-- 9. Add IDENTITY column ProductCode starting from 1000 increment by 5
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000,5);
