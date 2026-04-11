-- =================================
-- Topic: Create, Alter, Drop Table
-- =================================

CREATE TABLE employees(
    id          SERIAL      PRIMARY KEY,
    name        VARCHAR(50),
    designation VARCHAR(50),
    salary      NUMERIC(10, 2)
);

-- Add new column
-- ALTER TABLE employees ADD COLUMN address VARCHAR(50);

-- Delete a column
-- ALTER TABLE employees DROP COLUMN address;

-- Rename a column
-- ALTER TABLE employees RENAME COLUMN "name" TO "full_name";

-- Change column data type
-- ALTER TABLE employees ALTER COLUMN salary TYPE DECIMAL(12, 2);

-- Set a default value for a column
-- ALTER TABLE employees ALTER COLUMN designation SET DEFAULT 'Staff';

-- Rename the table
-- ALTER TABLE employees RENAME TO staffs;

-- DROP table
-- DROP TABLE IF EXISTS employees;