-- ============================================
-- Topic: WHERE — Filtering Rows
-- Description: Comparison operators, logical operators,
--              IN, BETWEEN and NULL checks
-- ============================================


-- Setup
-- Create table and manipulate data
CREATE TABLE products (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    category    VARCHAR(50)     NOT NULL,
    price       NUMERIC(10, 2)  NOT NULL,
    stock       INTEGER         DEFAULT 0,
    is_active   BOOLEAN         DEFAULT TRUE
);
INSERT INTO products (name, category, price, stock, is_active)
VALUES
    ('Wireless Mouse',      'Electronics',  2000,   100,    TRUE),
    ('Mechanical Keyboard', 'Electronics',  8000,   30,     TRUE),
    ('USB-C Hub',           'Electronics',  3000,   14,     TRUE),
    ('Standing Desk',       'Furniture',    18000,  6,      TRUE),
    ('Ergonomic Chair',     'Furniture',    15000,  15,     TRUE),
    ('Notebook A5',         'Stationery',   120,    500,    TRUE),
    ('Ballpoint Pen',       'Stationery',   10,     1000,   TRUE),
    ('Monitor 27"',         'Electronics',  29000,  40,     FALSE),
    ('Desk Lamp',           'Furniture',    2500,   0,      FALSE),
    ('Sticky Notes',        'Stationery',   90,     NULL,   TRUE);


--⭐ ----- COMPARISON OPERATORS -----
SELECT * FROM products WHERE price > 15000;
SELECT * FROM products WHERE price < 15000;
SELECT * FROM products WHERE price >= 15000;
SELECT * FROM products WHERE price = 15000;
SELECT * FROM products WHERE price != 15000;
SELECT * FROM products WHERE price <> 15000;    -- same as !=, both are valid


--⭐ ----- LOGICAL OPERATORS: AND, OR, NOT -----
SELECT * FROM products WHERE category = 'Electronics' AND price < 15000;
SELECT * FROM products WHERE category = 'Furniture' OR category = 'Stationery';
SELECT * FROM products WHERE NOT category = 'Stationery';
SELECT * FROM products WHERE NOT is_active;     -- returns inactive products

-- ⚠️  AND is evaluated before OR
SELECT * FROM products
WHERE category = 'Electronics' OR category = 'Furniture' AND price > 15000;
-- PostgreSQL reads this as: Electronics OR (Furniture AND price > 15000)

-- Use parentheses to make intent explicit
SELECT * FROM products
WHERE (category = 'Electronics' OR category = 'Furniture') AND price > 15000;


--⭐ ----- IN — MATCH AGAINST A LIST -----
-- Cleaner alternative to multiple OR conditions
SELECT * FROM products WHERE category IN ('Electronics', 'Stationery');

-- NOT IN — exclude a list
SELECT * FROM products WHERE category NOT IN ('Stationery');

-- ⚠️ NOT IN with NULLs is a trap (NULL comparisons are never TRUE/FALSE)
-- If any value in the list is NULL, the entire NOT IN returns no rows 
-- Always make sure IN list has no NULLs


--⭐ ----- BETWEEN — RANGE FILTER -----
-- BETWEEN is inclusive on both ends
SELECT * FROM products WHERE price BETWEEN 5000 AND 15000;
-- Equivalent to:
SELECT * FROM products WHERE price >= 5000 AND price <= 15000;

-- NOT BETWEEN
SELECT * FROM products WHERE price NOT BETWEEN 5000 AND 15000;


--⭐ ----- NULL CHECKS -----
SELECT * FROM products WHERE stock IS NULL;
SELECT * FROM products WHERE stock IS NOT NULL;

-- Never use equal on NULL checking
-- SELECT * FROM products WHERE stock = NULL;   -- returns 0 rows, always
-- NULL is not equals to anyting
