-- ============================================
-- Topic: LEFT JOIN & RIGHT JOIN
-- Description: Return all rows from one side,
--              with NULLs where no match exists
--              on the other side.
-- ============================================


-- Same setup as previous inner join
CREATE TABLE IF NOT EXISTS departments (
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
    ('Nadir Alam',      NULL,   55000.00);  -- no department assigned



--⭐ ----- LEFT JOIN -----
-- Returns ALL rows from the LEFT table (employees)
-- Matched rows from RIGHT table (departments) fill in normally
-- Unmatched rows from LEFT get NULL for all RIGHT table columns
SELECT
    e.name          AS employee,
    d.name          AS department,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;



--⭐ ----- FIND UNMATCHED ROWS WITH LEFT JOIN -----
-- A very common pattern: find rows with no match on the right side
-- Employees with no department assigned
SELECT
    e.name      AS employee_without_department,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;     -- NULL on right side means no match was found

-- Use WHERE right_table.id IS NULL, not WHERE e.department_id IS NULL



--⭐ ----- RIGHT JOIN -----
-- Returns ALL rows from the RIGHT table (departments)
-- Unmatched rows from RIGHT get NULL for all LEFT table columns

SELECT
    e.name          AS employee,    -- NULL for Design department
    d.name          AS department,
    d.budget
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;



--⭐ ----- FIND UNMATCHED ROWS WITH RIGHT JOIN -----
-- Departments with no employees assigned
SELECT
    d.name      AS department_without_employees,
    d.budget
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id
WHERE e.id IS NULL;



--⭐ ----- LEFT JOIN IS PREFERRED OVER RIGHT JOIN -----
-- RIGHT JOIN can always be rewritten as a LEFT JOIN by swapping table order
-- Most developers stick to LEFT JOIN for consistency and readability

-- These two queries return identical results:

-- Using RIGHT JOIN
SELECT e.name, d.name AS department
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- Using LEFT JOIN (preferred — just swap table order)
SELECT e.name, d.name AS department
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id;



--⭐ ----- LEFT JOIN WITH AGGREGATES -----
-- Count employees per department with total salary
SELECT
    d.name                  AS department,
    COUNT(e.id)             AS headcount,
    SUM(e.salary)           AS total_salary
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.name
ORDER BY headcount DESC;

-- NOTE:
-- COUNT(*) counts the NULL row itself → returns 1 for empty departments
-- COUNT(e.id) skips NULLs → correctly returns 0 for empty departments



-- CLEANUP
-- DROP TABLE IF EXISTS departments;
-- DROP TABLE IF EXISTS employees;
-- DROP TABLE IF EXISTS projects;