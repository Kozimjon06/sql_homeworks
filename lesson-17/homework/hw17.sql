----------------------------------------------------------
-- Task 1: Report of all distributors and their sales by region
----------------------------------------------------------
DROP TABLE IF EXISTS #RegionSales;
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);

INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

SELECT r.Region, d.Distributor, ISNULL(s.Sales,0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN #RegionSales s
    ON r.Region = s.Region AND d.Distributor = s.Distributor
ORDER BY r.Region, d.Distributor;

----------------------------------------------------------
-- Task 2: Managers with at least five direct reports
----------------------------------------------------------
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);

TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT e.name
FROM Employee e
JOIN Employee r ON e.id = r.managerId
GROUP BY e.id, e.name
HAVING COUNT(r.id) >= 5;

----------------------------------------------------------
-- Task 3: Products with at least 100 units ordered in Feb 2020
----------------------------------------------------------
DROP TABLE IF EXISTS Products, Orders;
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);

INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');

INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

----------------------------------------------------------
-- Task 4: Vendor from which each customer placed the most orders
----------------------------------------------------------
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);

INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

SELECT CustomerID, Vendor
FROM (
    SELECT CustomerID, Vendor,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM Orders
    GROUP BY CustomerID, Vendor
) t
WHERE rn = 1;

----------------------------------------------------------
-- Task 5: Check if a number is prime
----------------------------------------------------------
DECLARE @Check_Prime INT = 91, @i INT = 2, @isPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i += 1;
END

IF @isPrime = 1 AND @Check_Prime > 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

----------------------------------------------------------
-- Task 6: Device signals and max location
----------------------------------------------------------
DROP TABLE IF EXISTS Device;
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);

INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

WITH LocationCount AS (
    SELECT Device_id, Locations, COUNT(*) AS cnt
    FROM Device
    GROUP BY Device_id, Locations
),
Ranked AS (
    SELECT Device_id, Locations, cnt,
           ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY cnt DESC) AS rn
    FROM LocationCount
)
SELECT r.Device_id,
       (SELECT COUNT(DISTINCT Locations) FROM Device d WHERE d.Device_id=r.Device_id) AS no_of_location,
       r.Locations AS max_signal_location,
       (SELECT COUNT(*) FROM Device d WHERE d.Device_id=r.Device_id) AS no_of_signals
FROM Ranked r
WHERE rn = 1;

----------------------------------------------------------
-- Task 7: Employees earning more than dept avg
----------------------------------------------------------
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);

INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN (
    SELECT DeptID, AVG(Salary) AS avgSal
    FROM Employee
    GROUP BY DeptID
) d ON e.DeptID = d.DeptID
WHERE e.Salary > d.avgSal;

----------------------------------------------------------
-- Task 8: Lottery winnings
----------------------------------------------------------
DROP TABLE IF EXISTS Numbers, Tickets;
CREATE TABLE Numbers (Number INT);
INSERT INTO Numbers VALUES (25),(45),(78);

CREATE TABLE Tickets (TicketID VARCHAR(10), Number INT);
INSERT INTO Tickets VALUES
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91);

WITH TicketMatch AS (
    SELECT t.TicketID, COUNT(DISTINCT t.Number) AS matched
    FROM Tickets t
    JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT SUM(CASE WHEN matched = (SELECT COUNT(*) FROM Numbers) THEN 100
                WHEN matched > 0 THEN 10 ELSE 0 END) AS Total_Winnings
FROM TicketMatch;

----------------------------------------------------------
-- Task 9: Spending by platform
----------------------------------------------------------
DROP TABLE IF EXISTS Spending;
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);

INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

WITH user_platform AS (
    SELECT User_id, Spend_date,
           MAX(CASE WHEN Platform='Mobile' THEN 1 ELSE 0 END) AS has_mobile,
           MAX(CASE WHEN Platform='Desktop' THEN 1 ELSE 0 END) AS has_desktop,
           SUM(Amount) AS total_amt
    FROM Spending
    GROUP BY User_id, Spend_date
)
SELECT ROW_NUMBER() OVER (ORDER BY Spend_date, Platform) AS Row,
       Spend_date,
       Platform,
       SUM(total_amt) AS Total_Amount,
       COUNT(User_id) AS Total_users
FROM (
    SELECT Spend_date, 
           CASE WHEN has_mobile=1 AND has_desktop=0 THEN 'Mobile'
                WHEN has_desktop=1 AND has_mobile=0 THEN 'Desktop'
                ELSE 'Both' END AS Platform,
           total_amt, User_id
    FROM user_platform
) t
GROUP BY Spend_date, Platform;

----------------------------------------------------------
-- Task 10: De-group quantities
----------------------------------------------------------
DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped (
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);

INSERT INTO Grouped VALUES ('Pencil',3), ('Eraser',4), ('Notebook',2);

WITH Numbers AS (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL 
    SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
)
SELECT g.Product, 1 AS Quantity
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product;
