/* ========================= EASY TASKS ========================= */

-- 1. Output "100-Steven King"
SELECT CAST(EMPLOYEE_ID AS VARCHAR) + '-' + FIRST_NAME + ' ' + LAST_NAME AS EmpDetails
FROM Employees
WHERE EMPLOYEE_ID = 100;

-- 2. Replace substring '124' with '999' in phone_number
UPDATE Employees
SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999');

-- 3. First name & length starting with A, J, or M
SELECT FIRST_NAME AS FirstName, LEN(FIRST_NAME) AS NameLength
FROM Employees
WHERE LEFT(FIRST_NAME,1) IN ('A','J','M')
ORDER BY FIRST_NAME;

-- 4. Total salary by ManagerID
SELECT MANAGER_ID, SUM(SALARY) AS TotalSalary
FROM Employees
GROUP BY MANAGER_ID;

-- 5. Year & highest value from TestMax
SELECT Year1,
       GREATEST(Max1, Max2, Max3) AS HighestValue
FROM TestMax;

-- 6. Odd numbered movies & not boring
SELECT movie, description
FROM cinema
WHERE id % 2 = 1 AND description <> 'boring';

-- 7. Sort with Id=0 last
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

-- 8. First non-null column (ssn, passportid, itin)
SELECT id, COALESCE(ssn, passportid, itin) AS FirstNonNull
FROM person;

/* ========================= MEDIUM TASKS ========================= */

-- 9. Split FullName into first, middle, last
SELECT StudentID,
       PARSENAME(REPLACE(FullName,' ','.'),3) AS FirstName,
       PARSENAME(REPLACE(FullName,' ','.'),2) AS MiddleName,
       PARSENAME(REPLACE(FullName,' ','.'),1) AS LastName
FROM Students;

-- 10. Orders delivered to Texas for customers who also delivered to California
SELECT o.*
FROM Orders o
WHERE DeliveryState = 'TX'
  AND CustomerID IN (SELECT CustomerID FROM Orders WHERE DeliveryState='CA');

-- 11. Group concatenate DMLTable
SELECT STRING_AGG(String,' ') AS QueryStatement
FROM DMLTable;

-- 12. Employees with at least 3 'a' in full name
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM Employees
WHERE (LEN(LOWER(FIRST_NAME+LAST_NAME)) - LEN(REPLACE(LOWER(FIRST_NAME+LAST_NAME),'a',''))) >= 3;

-- 13. Count employees per department & % with >3 years
SELECT DEPARTMENT_ID,
       COUNT(*) AS TotalEmployees,
       100.0 * SUM(CASE WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE()) > 3 THEN 1 ELSE 0 END)/COUNT(*) AS PercentMoreThan3Years
FROM Employees
GROUP BY DEPARTMENT_ID;

-- 14. Most and least experienced spacemen per job
SELECT JobDescription,
       MAX_BY(SpacemanID, MissionCount) AS MostExperienced,
       MIN_BY(SpacemanID, MissionCount) AS LeastExperienced
FROM Personal
GROUP BY JobDescription;

/* ========================= DIFFICULT TASKS ========================= */

-- 15. Separate uppercase, lowercase, numbers, and others from string
WITH chars AS (
    SELECT value AS ch
    FROM STRING_SPLIT('tf56sd#%OqH','')
    WHERE value <> ''
)
SELECT 
       STRING_AGG(CASE WHEN ch LIKE '[A-Z]' THEN ch END,'') AS Uppercase,
       STRING_AGG(CASE WHEN ch LIKE '[a-z]' THEN ch END,'') AS Lowercase,
       STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END,'') AS Numbers,
       STRING_AGG(CASE WHEN ch NOT LIKE '[A-Za-z0-9]' THEN ch END,'') AS Others
FROM chars;

-- 16. Running sum in Students
SELECT StudentID, FullName, Grade,
       SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSum
FROM Students;

-- 17. Solve equations
UPDATE Equations
SET TotalSum = (SELECT SUM(CAST(value AS INT)) 
                FROM STRING_SPLIT(REPLACE(REPLACE(Equation,'+',' '),'-',' -'),' ')
                WHERE value <> '');

SELECT * FROM Equations;

-- 18. Students with same birthday
SELECT Birthday, STRING_AGG(StudentName, ', ') AS Students
FROM Student
GROUP BY Birthday
HAVING COUNT(*) > 1;

-- 19. Aggregate scores per unique player pair
SELECT LEAST(PlayerA, PlayerB) AS Player1,
       GREATEST(PlayerA, PlayerB) AS Player2,
       SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY LEAST(PlayerA, PlayerB), GREATEST(PlayerA, PlayerB);
