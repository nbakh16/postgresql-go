-- ============================================
-- Topic: DELETE & TRUNCATE — Removing Rows
-- Description: Delete with conditions,
--              DELETE with RETURNING,
--              TRUNCATE vs DELETE, 
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


-- ----- BASIC DELETE -----
DELETE FROM employees
WHERE id = 1;
-- WHERE designation = 'Staff'; -- or delete based on condition
-- Always use WHERE with DELETE — without it every row gets deleted


-- Delete rows matching multiple conditions
DELETE FROM employees
WHERE designation = 'Accountant' AND salary < 70000.00;


-- ----- DELETE WITH RETURNING -----
-- Returns the deleted rows immediately — useful for logging or confirmation
DELETE FROM employees
WHERE designation = 'Marketer'
RETURNING id, name, designation, salary;
-- RETURNING *;


-- ----- DELETE ALL ROWS -----
-- DELETE FROM employees;
-- Deletes every row but keeps the table structure intact
-- This deletes EVERY row — almost never what you want


-- ----- TRUNCATE — FASTER ALTERNATIVE -----
-- TRUNCATE removes all rows much faster than DELETE for large tables
-- TRUNCATE TABLE employees;

-- TRUNCATE and reset the SERIAL counter back to 1
-- TRUNCATE TABLE employees RESTART IDENTITY;

-- TRUNCATE multiple tables at once
-- TRUNCATE TABLE employees, customers;


-- ----- DELETE vs TRUNCATE -----
-- DELETE:
--   ✓ Can use WHERE to target specific rows
--   ✓ Fires ON DELETE triggers for every row
--   ✓ Can be rolled back inside a transaction
--   ✗ Slower, processes rows one by one.

-- TRUNCATE:
--   ✓ Much faster on large tables
--   ✓ Can reset SERIAL/IDENTITY counters
--   ✓ Can still be rolled back inside a transaction
--   ✗ Cannot use WHERE — always removes all rows
--   ✗ Bypasses ON DELETE triggers


-- ----- NOTE -----
-- Always use WHERE with DELETE — without it every row gets deleted
-- SAFE PRACTICE: run the equivalent SELECT first to verify what will be deleted
-- SELECT * FROM employees WHERE designation = 'Accountant';  -- verify first
-- DELETE FROM employees WHERE designation = 'Accountant';    -- then delete
