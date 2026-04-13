-- ============================================
-- Topic: UPDATE — Modifying Rows
-- Description: Basic update, update multiple columns,
--              update with conditions,
--              update with RETURNING
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


-- ----- BASIC UPDATE -----
UPDATE employees
SET salary = 80000.00
WHERE id = 1;
-- Always use WHERE with UPDATE — without it every row gets updated


-- ----- UPDATE MULTIPLE COLUMNS -----
UPDATE employees
SET
    designation = 'Sr Accountant',
    salary      = 90000.00
WHERE id = 1;


-- ----- UPDATE BASED ON CURRENT VALUE -----
-- Give all Accountants a 10% raise
UPDATE employees
SET salary = salary * 1.10
WHERE designation = 'Accountant';

-- Increment 5000 salary of HR
UPDATE employees
SET salary = salary + 5000
WHERE designation = 'HR';


-- ----- UPDATE WITH RETURNING -----
-- Returns the updated rows immediately — no need for a follow-up SELECT
UPDATE employees
SET 
    designation = 'Lead Designer'
    salary = salary * 1.10
WHERE id = 6
RETURNING id, name, designation, salary;


-- ----- NOTE -----
-- Always use WHERE with UPDATE — without it every row gets updated
-- SAFE PRACTICE: before running an UPDATE, run the equivalent SELECT first
-- SELECT * FROM employees WHERE designation = 'Accountant';  -- verify first
-- UPDATE employees SET salary = salary * 1.10 WHERE designation = 'Accountant'; -- then update
