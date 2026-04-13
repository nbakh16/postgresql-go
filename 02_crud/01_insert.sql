-- ============================================
-- Topic: INSERT — Adding Rows
-- Description: Single insert, multi-row insert,
--              DEFAULT value, INSERT with RETURNING,
-- ============================================


-- Create initial table
CREATE TABLE employees (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    designation VARCHAR(50)     DEFAULT 'Staff',
    salary      NUMERIC(10, 2)  NOT NULL,
    joined_at   TIMESTAMPTZ     DEFAULT NOW()
);


-- ----- BASIC INSERT -----
-- All columns explicitly listed (recommended — safe against schema changes)
INSERT INTO employees (name, designation, salary)
VALUES ('John Doe', 'Accountant', 75000.00);

-- Skipping a column that has a DEFAULT value
INSERT INTO employees (name, salary)
VALUES ('John Jen', 40000.00);         -- designation defaults to 'Staff'


-- ----- MULTI-ROW INSERT -----
-- Inserting multiple rows in a single statement — more efficient than separate INSERTs
INSERT INTO employees (name, designation, salary)
VALUES
    ('Mr Rahim', 'Manager', 80000.00),
    ('Karim Rahman', 'Marketer', 50000.00),
    ('Sadia Israt','HR', 65000.00);


-- ----- INSERT WITH RETURNING -----
-- RETURNING gives back column values from the inserted row — no need for a separate SELECT
INSERT INTO employees (name, designation, salary)
VALUES ('Faruk Ahmed', 'Designer', 50000.00)
RETURNING id, name, joined_at;
-- RETURNING *; -- returns all columns
