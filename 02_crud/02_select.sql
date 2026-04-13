-- ============================================
-- Topic: SELECT — Querying Rows
-- Description: Basic select, column aliasing, filtering,
--              null check, pattern matching, 
--              distinct, sorting, limiting,
-- ============================================


-- Manipulate data for selection queries
-- Skip if already have data from previous step 01_select.sql
CREATE TABLE IF NOT EXISTS employees (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    designation VARCHAR(50)     DEFAULT 'Staff',
    salary      NUMERIC(10, 2)  NOT NULL,
    joined_at   TIMESTAMPTZ     DEFAULT NOW()
);
INSERT INTO employees (name, designation, salary)
VALUES
    ('John Doe', 'Accountant', 75000.00),
    ('John Jen', NULL, 40000.00),
    ('Mr Rahim', 'Manager', 80000.00),
    ('Karim Rahman', 'Marketer', 50000.00),
    ('Sadia Israt','HR', 65000.00),
    ('Faruk Ahmed', 'Designer', 50000.00),
    ('Ms Nasreen', 'Accountant', 60000.00);



-- ----- BASIC SELECT -----
-- All columns
SELECT * FROM employees;

-- Specific columns only (preferred in production)
SELECT name, designation, salary FROM employees;


-- ----- COLUMN ALIASING -----
-- AS renames a column in the result output only — does not change the table
SELECT
    name            AS employee_name,
    salary          AS monthly_salary,
    salary * 12     AS annual_salary        -- expressions work too
FROM employees;


-- ----- FILTERING WITH WHERE -----
SELECT * FROM employees WHERE designation = 'Accountant';
SELECT * FROM employees WHERE salary > 65000;
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 80000;   -- inclusive

-- Multiple conditions
SELECT * FROM employees WHERE designation = 'Accountant' AND salary > 70000;
SELECT * FROM employees WHERE designation = 'Manager'  OR  designation = 'HR';

-- IN — cleaner alternative to multiple OR conditions
SELECT * FROM employees WHERE designation IN ('Manager', 'HR', 'Accountant');

-- NOT IN
SELECT * FROM employees WHERE designation NOT IN ('Accountant');


-- ----- NULL CHECKS -----
-- NEVER use = NULL; always use IS NULL or IS NOT NULL
SELECT * FROM employees WHERE designation IS NULL;
SELECT * FROM employees WHERE designation IS NOT NULL;


-- ----- PATTERN MATCHING WITH LIKE -----
-- % matches any sequence of characters, _ matches exactly one character
SELECT * FROM employees WHERE name LIKE 'M%';       -- names starting with 'M'
SELECT * FROM employees WHERE name LIKE '%Ahmed';   -- names ending with 'Ahmed'
SELECT * FROM employees WHERE name LIKE '%a%';      -- names containing 'a'
SELECT * FROM employees WHERE name LIKE '_o%';      -- second character is 'o'

-- ILIKE is case-insensitive (PostgreSQL-specific)
SELECT * FROM employees WHERE name ILIKE '%Ahmed%';


-- ----- DISTINCT — REMOVE DUPLICATES -----
-- Returns only unique values in the result set
SELECT DISTINCT designation FROM employees;

-- Distinct across multiple columns (combination must be unique)
SELECT DISTINCT designation, salary FROM employees;


-- ----- SORTING DATA -----
SELECT * FROM employees ORDER BY salary ASC;    -- ASC (low to high), DESC (High to Low)
SELECT * FROM employees ORDER BY designation ASC, salary DESC;  -- multi-column sort


-- ----- LIMITING RESULTS -----
SELECT * FROM employees ORDER BY salary DESC LIMIT 3;   -- top 3 salary
SELECT * FROM employees ORDER BY salary DESC LIMIT 3 OFFSET 1; -- skip the top 1, get next 3
-- OFFSET is useful for pagination but gets slow on large tables
