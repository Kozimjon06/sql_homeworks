----------------------------------------------------------
-- Puzzle 1: Finding Distinct Values based on two columns
----------------------------------------------------------
-- Method 1: Use DISTINCT with LEAST/GREATEST (to handle order)
SELECT DISTINCT 
       LEAST(col1, col2) AS col1, 
       GREATEST(col1, col2) AS col2
FROM InputTbl;

-- Method 2: Use GROUP BY on ordered pairs
SELECT 
       CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
       CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl
GROUP BY 
       CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
       CASE WHEN col1 < col2 THEN col2 ELSE col1 END;

----------------------------------------------------------
-- Puzzle 2: Removing Rows with All Zeroes
----------------------------------------------------------
SELECT *
FROM TestMultipleZero
WHERE COALESCE(A,0) + COALESCE(B,0) + COALESCE(C,0) + COALESCE(D,0) <> 0;

----------------------------------------------------------
-- Puzzle 3: Find those with odd ids
----------------------------------------------------------
SELECT * 
FROM section1
WHERE id % 2 = 1;

----------------------------------------------------------
-- Puzzle 4: Person with the smallest id
----------------------------------------------------------
SELECT *
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);

----------------------------------------------------------
-- Puzzle 5: Person with the highest id
----------------------------------------------------------
SELECT *
FROM section1
WHERE id = (SELECT MAX(id) FROM section1);

----------------------------------------------------------
-- Puzzle 6: People whose name starts with b
----------------------------------------------------------
SELECT *
FROM section1
WHERE name LIKE 'B%';

----------------------------------------------------------
-- Puzzle 7: Rows where code contains underscore (_ literally)
----------------------------------------------------------
SELECT *
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';
