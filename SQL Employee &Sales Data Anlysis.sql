-- SQL Employee & Sales Data Analysis | MySQL
-- Project recreated from the uploaded project PDF.

-- =========================================================
-- 1. EMPLOYEE DATASET
-- =========================================================

DROP DATABASE IF EXISTS company_db;
CREATE DATABASE company_db;
USE company_db;

CREATE TABLE Employees (
    Emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(50),
    salary INT
);

INSERT INTO Employees VALUES
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);

SELECT * FROM Employees;


-- =========================================================
-- 2. DEPARTMENT DATASET
-- =========================================================

USE company_db;

CREATE TABLE Department (
    Department_id VARCHAR(50) PRIMARY KEY,
    Department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO Department VALUES
('D01', 'Sales', 'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance', 'Pune'),
('D04', 'HR', 'Bengaluru'),
('D05', 'IT', 'Hyderabad');

SELECT * FROM Department;


-- =========================================================
-- 3. SALES DATASET
-- =========================================================

USE company_db;

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    Sale_id INT PRIMARY KEY,
    Emp_id INT,
    Sale_amount INT,
    Sale_date DATE
);

INSERT INTO Sales VALUES
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 1200, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');

SELECT * FROM Sales;


-- =========================================================
-- 4. BASIC LEVEL QUERIES
-- =========================================================

-- 1. Retrieve the names of employees who earn more than
-- the average salary of all employees.
SELECT name
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 2. Find the employees who belong to the department
-- with the highest average salary.
SELECT name
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

-- 3. List all employees who have made at least one sale.
SELECT name
FROM Employees
WHERE Emp_id IN (SELECT DISTINCT Emp_id FROM Sales);

-- 4. Find the employee with the highest sale amount.
SELECT name
FROM Employees
WHERE Emp_id = (
    SELECT Emp_id
    FROM Sales
    ORDER BY Sale_amount DESC
    LIMIT 1
);

-- 5. Retrieve the names of employees whose salaries are
-- higher than Shubham's salary.
SELECT name
FROM Employees
WHERE salary > (
    SELECT salary
    FROM Employees
    WHERE name = 'Shubham'
);


-- =========================================================
-- 5. INTERMEDIATE LEVEL QUERIES
-- =========================================================

-- 1. Find employees who work in the same department as Abhishek.
SELECT name
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Employees
    WHERE name = 'Abhishek'
);

-- 2. List departments that have at least one employee
-- earning more than 60,000.
SELECT Department_name
FROM Department
WHERE Department_id IN (
    SELECT DISTINCT department_id
    FROM Employees
    WHERE salary > 60000
);

-- 3. Find the department name of the employee
-- who made the highest sale.
SELECT Department_name
FROM Department
WHERE Department_id = (
    SELECT department_id
    FROM Employees
    WHERE Emp_id = (
        SELECT Emp_id
        FROM Sales
        ORDER BY Sale_amount DESC
        LIMIT 1
    )
);

-- 4. Retrieve employees who have made sales greater
-- than the average sale amount.
SELECT DISTINCT e.name
FROM Employees e
JOIN Sales s ON e.Emp_id = s.Emp_id
WHERE s.Sale_amount > (SELECT AVG(Sale_amount) FROM Sales);

-- 5. Find the total sales made by employees who earn
-- more than the average salary.
SELECT SUM(s.Sale_amount) AS total_sales
FROM Sales s
WHERE s.Emp_id IN (
    SELECT Emp_id
    FROM Employees
    WHERE salary > (SELECT AVG(salary) FROM Employees)
);


-- =========================================================
-- 6. ADVANCED LEVEL QUERIES
-- =========================================================

-- 1. Find employees who have not made any sales.
SELECT name
FROM Employees
WHERE Emp_id NOT IN (SELECT Emp_id FROM Sales);

-- 2. List departments where the average salary is above 55,000.
SELECT Department_name
FROM Department
WHERE Department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING AVG(salary) > 55000
);

-- 3. Retrieve department names where the total sales exceed 10,000.
SELECT Department_name
FROM Department
WHERE Department_id IN (
    SELECT e.department_id
    FROM Employees e
    JOIN Sales s ON e.Emp_id = s.Emp_id
    GROUP BY e.department_id
    HAVING SUM(s.Sale_amount) > 10000
);

-- 4. Find the employee who has made the second-highest sale.
SELECT name
FROM Employees
WHERE Emp_id = (
    SELECT Emp_id
    FROM Sales
    ORDER BY Sale_amount DESC
    LIMIT 1 OFFSET 1
);

-- 5. Retrieve the names of employees whose salary is greater
-- than the highest sale amount recorded.
SELECT name
FROM Employees
WHERE salary > (SELECT MAX(Sale_amount) FROM Sales);
