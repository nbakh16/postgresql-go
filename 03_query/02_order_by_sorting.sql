-- ============================================
-- Topic: ORDER BY — Sorting Results
-- Description: Ascending/descending sort,
--              multi-column sort, NULL ordering,
-- ============================================


-- Create table and manipulate data
-- Skip if already have data from previous step 01_where_filter.sql
CREATE TABLE IF NOT EXISTS products (
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


--⭐ ----- BASIC SORTING -----
SELECT * FROM products ORDER BY name ASC; -- Ascending is default
SELECT * FROM products ORDER BY price DESC; -- price (high to low)


--⭐ ----- MULTI-COLUMN SORT -----
-- First sorted by category A->Z, then within each category by price high->low
SELECT * FROM products ORDER BY category ASC, price DESC;


--⭐ ----- SORTING BY EXPRESSION -----
-- Sort by a calculated value
SELECT name, price, price * stock AS total_stock_price
FROM products
ORDER BY price * stock DESC;
-- ORDER BY total_stock_price DESC; -- postgress allows this alias too


--⭐ ----- NULL ORDERING -----
-- By default: NULLs sort LAST in ASC, FIRST in DESC
-- Override NULL position explicitly
SELECT name, stock FROM products ORDER BY stock ASC NULLS FIRST;
SELECT name, stock FROM products ORDER BY stock DESC NULLS LAST;


--⭐ ----- ORDER BY WITH LIMIT -----
 -- top 3 highest price products
SELECT name, price, stock FROM products ORDER BY price DESC LIMIT 3;
