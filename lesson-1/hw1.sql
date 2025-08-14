--task 1
--Data refers to raw facts, figures, or information that can be collected, stored, and processed. It can be numbers, text, images, audio, or video and may not have meaning on its own until it is analyzed or organized.
--A database is an organized collection of data that is stored and accessed electronically. It allows data to be easily managed, updated, and retrieved.
--A relational database is a type of database that stores data in a structured format using tables. It uses relationships between tables through keys (like primary and foreign keys) to connect and organize data efficiently.
--table is a collection of related data organized in rows and columns within a database. Each row represents a single record, and each column represents a field or attribute of that record.
--task 2
--1. Data Storage and Management,2. Security Features,3. High Availability and Disaster Recovery,4. Business Intelligence (BI) Tools,5. Support for T-SQL (Transact-SQL)
--task 3
--1.Windows authentication, 2. SQL Server Authentication 
--task 4
CREATE DATABASE SchoolDB;
--task 5
GO
USE SchoolDB;
GO
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);
--task 6
--SQL Server: A relational database management system (RDBMS) developed by Microsoft to store, manage, and retrieve data.
--SSMS (SQL Server Management Studio): A graphical tool used to manage SQL Server, write and run SQL queries, and administer databases.
--SQL (Structured Query Language): A language used to communicate with and manipulate databases (e.g., SELECT, INSERT, UPDATE).

--task 7


--1. DQL (Data Query Language): Used to query data.
--example:
SELECT * FROM Students;

--2. DML (Data Manipulation Language): Used to modify data.
--example:
INSERT INTO Students VALUES (1, 'John', 20);
UPDATE Students SET Age = 21 WHERE StudentID = 1;

--3. DDL (Data Definition Language): Used to define or change structure.
--example:
CREATE TABLE Students (...);

--4. DCL (Data Control Language): Used to control access
--example:
GRANT SELECT ON Students TO User1;

--5. TCL (Transaction Control Language): Used to manage transactions.
--example:
BEGIN TRANSACTION;
COMMIT;
ROLLBACK;

--task 8
INSERT INTO Students (StudentID, Name, Age) VALUES
(1, 'Alice', 18),
(2, 'Bob', 20),
(3, 'Charlie', 19);
--task 9 
--finished during class
