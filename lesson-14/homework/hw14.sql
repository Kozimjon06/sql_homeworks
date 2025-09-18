----------------------------------------------------------
-- Lesson 14: Date and Time Functions Practice Solutions
-- SQL Server
----------------------------------------------------------

---------------------
-- EASY TASKS
---------------------

-- 1. Split the Name column into Name and Surname (TestMultipleColumns)
SELECT 
    Id,
    LTRIM(RTRIM(PARSENAME(REPLACE(Name, ',', '.'), 2))) AS FirstName,
    LTRIM(RTRIM(PARSENAME(REPLACE(Name, ',', '.'), 1))) AS LastName
FROM TestMultipleColumns;

-- 2. Find strings containing '%' (TestPercent)
SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';

-- 3. Split a string based on dot(.) (Splitter)
SELECT 
    Id,
    value AS Part
FROM Splitter
CROSS APPLY STRING_SPLIT(Vals, '.');

-- 4. Rows where Vals contains more than two dots (testDots)
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

-- 5. Count spaces in string (CountSpaces)
SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- 6. Employees who earn more than their managers (Employee)
SELECT e.Id, e.Name, e.Salary
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

-- 7. Employees with service between 10 and 15 years (Employees)
SELECT 
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 15;

---------------------
-- MEDIUM TASKS
---------------------

-- 8. Dates with higher temperature than yesterday (weather)
SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 
  ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;

-- 9. First login date for each player (Activity)
SELECT 
    player_id, 
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

-- 10. Return the third item from fruit list (fruits)
SELECT 
    LTRIM(RTRIM(value)) AS third_fruit
FROM fruits
CROSS APPLY STRING_SPLIT(fruit_list, ',')
WHERE ordinal = 3
ORDER BY fruit_list, ordinal
-- Trick: add ROW_NUMBER() since STRING_SPLIT doesn’t guarantee order
-- Use a CTE for stable third item:
;WITH FruitCTE AS (
    SELECT fruit_list, value,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM fruits
    CROSS APPLY STRING_SPLIT(fruit_list, ',')
)
SELECT value AS third_fruit
FROM FruitCTE
WHERE rn = 3;

-- 11. Employment Stage (Employees)
SELECT 
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME,
    HIRE_DATE,
    CASE 
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

-- 12. Extract integer value at start of string (GetIntegers)
SELECT 
    Id,
    TRY_CAST(
        LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'X') - 1) AS INT
    ) AS StartingInteger
FROM GetIntegers;

---------------------
-- DIFFICULT TASKS
---------------------

-- 13. Swap first two letters of comma separated string (MultipleVals)
SELECT 
    Id,
    STUFF(Vals, 1, 2, SUBSTRING(Vals, 2, 1) + SUBSTRING(Vals, 1, 1))
    AS SwappedVals
FROM MultipleVals;

-- 14. Convert each character of a string into a row
DECLARE @str VARCHAR(100) = 'sdgfhsdgfhs@121313131';
;WITH Numbers AS (
    SELECT TOP (LEN(@str)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
SELECT SUBSTRING(@str, n, 1) AS Character
FROM Numbers;

-- 15. Report the first device logged in for each player (Activity)
SELECT player_id, device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date) 
    FROM Activity 
    WHERE player_id = a.player_id
);

-- 16. Separate integer values and character values (rtcfvty34redt)
DECLARE @val VARCHAR(100) = 'rtcfvty34redt';
SELECT 
    @val AS OriginalString,
    REPLACE(@val, '%[^0-9]%', '') AS Digits,
    REPLACE(@val, '%[0-9]%', '') AS Letters;

----------------------------------------------------------
-- END OF SCRIPT
----------------------------------------------------------
