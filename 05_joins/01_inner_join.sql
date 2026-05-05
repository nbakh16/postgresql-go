-- ==============================================
-- Topic: INNER JOIN
-- Return only rows that have a match in both tables. 
-- Unmatched rows from either side are excluded.
-- ==============================================


-- Setup tables
CREATE TABLE departments (
    id      SERIAL          PRIMARY KEY,
    name    VARCHAR(100)    NOT NULL,
    budget  NUMERIC(10, 2)
);
CREATE TABLE employees (
    id              SERIAL          PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    department_id   INTEGER         REFERENCES departments(id),
    salary          NUMERIC(10, 2)  NOT NULL
);

INSERT INTO departments (name, budget)
VALUES
    ('Engineering', 90000.00),
    ('Marketing',   80000.00),
    ('HR',          50000.00),
    ('Finance',     60000.00);

INSERT INTO employees (name, department_id, salary)
VALUES
    ('Mr Rahim',        1,      85000.00),
    ('Karim Rahman',    2,      52000.00),
    ('Sadia Israt',     1,      92000.00),
    ('Faruk Ahmed',     3,      48000.00),
    ('Ms Nasreen',      2,      61000.00),
    ('Nazrul Islam',    1,      78000.00),
    ('Nadir Alam',      NULL,   55000.00);  -- no department assigned — excluded from INNER JOIN



--⭐ ----- BASIC INNER JOIN -----
-- Returns only employees who have a matching department
-- Nadir Alam (NULL department) and Finance department (no employees) are both excluded
SELECT
    e.name          AS employee,
    d.name          AS department,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- INNER keyword is optional — JOIN alone defaults to INNER JOIN



--⭐ ----- TABLE ALIASES -----
-- Always alias tables in joins — keeps queries readable especially with 3+ tables
-- Convention: short meaningful alias (e => employees, d => departments)
-- Prefix all columns with alias to avoid ambiguity
SELECT
    e.id,
    e.name          AS employee,
    d.name          AS department   -- without alias, two 'name' columns would collide
FROM employees e
JOIN departments d ON e.department_id = d.id;



--⭐ ----- INNER JOIN WITH WHERE -----
-- Filter after joining
SELECT
    e.name      AS employee,
    d.name      AS department,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE d.name = 'Engineering'
ORDER BY e.salary DESC;



--⭐ ----- INNER JOIN WITH AGGREGATES -----
-- Total salary cost and headcount per department
SELECT
    d.name              AS department,
    COUNT(e.id)         AS headcount,
    SUM(e.salary)       AS total_salary,
    AVG(e.salary)       AS avg_salary
FROM departments d
JOIN employees e ON e.department_id = d.id
GROUP BY d.name
ORDER BY total_salary DESC;



--⭐ ----- JOINING MORE THAN TWO TABLES -----
CREATE TABLE projects (
    id              SERIAL          PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    department_id   INTEGER         REFERENCES departments(id)
);

INSERT INTO projects (name, department_id)
VALUES
    ('Project 1',   1),
    ('Project 2',   2),
    ('Project 3',   3),
    ('Project 4',   1);

-- Chain joins — each JOIN adds another table to the result
SELECT
    e.name          AS employee,
    d.name          AS department,
    p.name          AS project
FROM employees e
JOIN departments d  ON e.department_id  = d.id
JOIN projects p     ON p.department_id  = d.id;



-- CLEANUP
-- DROP TABLE IF EXISTS departments;
-- DROP TABLE IF EXISTS employees;
-- DROP TABLE IF EXISTS projects;