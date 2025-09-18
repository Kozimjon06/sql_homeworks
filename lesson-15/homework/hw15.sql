----------------------------------------------------------
-- Lesson 15: Subqueries and EXISTS
-- SQL Server
----------------------------------------------------------

-------------------------
-- LEVEL 1: BASIC SUBQUERIES
-------------------------

-- 1. Employees with Minimum Salary
SELECT *
FROM employees e
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 2. Products Above Average Price
SELECT *
FROM products p
WHERE price > (SELECT AVG(price) FROM products);

-------------------------
-- LEVEL 2: NESTED SUBQUERIES WITH CONDITIONS
-------------------------

-- 3. Employees in Sales Department
SELECT *
FROM employees e
WHERE department_id = (
    SELECT id FROM departments WHERE department_name = 'Sales'
);

-- 4. Customers with No Orders
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-------------------------
-- LEVEL 3: AGGREGATION & GROUPING IN SUBQUERIES
-------------------------

-- 5. Products with Max Price in Each Category
SELECT p.*
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);

-- 6. Employees in Department with Highest Average Salary
SELECT *
FROM employees e
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);

-------------------------
-- LEVEL 4: CORRELATED SUBQUERIES
-------------------------

-- 7. Employees Earning Above Department Average
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- 8. Students with Highest Grade per Course
SELECT s.student_id, s.name, g.course_id, g.grade
FROM grades g
JOIN students s ON s.student_id = g.student_id
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);

-------------------------
-- LEVEL 5: RANKING & COMPLEX CONDITIONS
-------------------------

-- 9. Third-Highest Price per Category
;WITH RankedProducts AS (
    SELECT p.*,
           DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rnk
    FROM products p
)
SELECT *
FROM RankedProducts
WHERE rnk = 3;

-- 10. Employees Salary Between Company Avg and Department Max
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
      SELECT MAX(salary)
      FROM employees
      WHERE department_id = e.department_id
  );

----------------------------------------------------------
-- END OF SCRIPT
----------------------------------------------------------
