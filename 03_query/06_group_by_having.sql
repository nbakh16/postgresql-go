-- ============================================
-- Topic: GROUP BY & HAVING
-- Description: Grouping rows, aggregating per group,
--              filtering groups with HAVING,
--              GROUP BY vs WHERE
-- ============================================


-- Setup — reusing same table from 05_aggregate_functions.sql
CREATE TABLE IF NOT EXISTS orders (
    id          SERIAL          PRIMARY KEY,
    customer    VARCHAR(100)    NOT NULL,
    product     VARCHAR(100)    NOT NULL,
    category    VARCHAR(50)     NOT NULL,
    amount      NUMERIC(10, 2)  NOT NULL,
    quantity    INTEGER         NOT NULL,
    status      VARCHAR(20)     DEFAULT 'pending',
    created_at  DATE            DEFAULT CURRENT_DATE
);

INSERT INTO orders (customer, product, category, amount, quantity, status, created_at)
VALUES
    ('Karim Rahman',    'Wireless Mouse',       'Electronics',  2000,   2,  'completed',    '2026-01-05'),
    ('Faruk Ahmed',     'Standing Desk',        'Furniture',    18000,  1,  'completed',    '2026-01-18'),
    ('Karim Rahman',    'Notebook A5',          'Stationery',   120,    10, 'completed',    '2026-02-01'),
    ('Sadia Israt',     'Mechanical Keyboard',  'Electronics',  8000,   1,  'completed',    '2026-02-14'),
    ('Tanvir Rahman',   'Ergonomic Chair',      'Furniture',    15000,  2,  'cancelled',    '2026-02-28'),
    ('Faruk Ahmed',     'USB-C Hub',            'Electronics',  3000,   3,  'completed',    '2026-03-10'),
    ('Sadia Israt',     'Standing Desk',        'Furniture',    18000,  1,  'pending',      '2026-03-22'),
    ('Karim Rahman',    'Monitor 27"',          'Electronics',  29000,  1,  'completed',    '2026-04-05'),
    ('Arif Chowdhury',  'Ballpoint Pen',        'Stationery',   10,     50, 'completed',    '2026-04-18'),
    ('Tanvir Rahman',   'Wireless Mouse',       'Electronics',  2000,   3,  'completed',    '2026-05-01'),
    ('Arif Chowdhury',  'Desk Lamp',            'Furniture',    2500,   2,  'cancelled',    '2026-05-15'),
    ('Faruk Ahmed',     'Sticky Notes',         'Stationery',   90,     20, 'pending',      '2026-06-01');



-- BASIC GROUP BY
-- Count orders per status
SELECT status, COUNT(*) AS total
FROM orders
GROUP BY status;

-- Total revenue per category
SELECT category, SUM(amount) AS total_revenue
FROM orders
GROUP BY category
ORDER BY total_revenue DESC;

-- ⚠️ Every column in SELECT must either be in GROUP BY or wrapped in an aggregate function
--
--  This is invalid, as product not in GROUP BY:
SELECT customer, product, COUNT(*) FROM orders GROUP BY customer; -- ❌



-- GROUP BY MULTIPLE COLUMNS
-- Revenue breakdown by category AND status
SELECT
    status,
    category,
    COUNT(*)        AS total_orders,
    SUM(amount)     AS total_revenue
FROM orders
GROUP BY status, category
ORDER BY status;



-- HAVING — FILTER GROUPS
-- Customers who placed more than 2 orders
SELECT customer, COUNT(*) AS order_count
FROM orders
GROUP BY customer
HAVING COUNT(*) > 2;

-- Categories with total revenue over 15000
SELECT category, SUM(amount) AS total_revenue
FROM orders
GROUP BY category
HAVING SUM(amount) > 15000
ORDER BY total_revenue DESC;



-- WHERE vs HAVING
-- WHERE: filters individual rows BEFORE grouping
-- HAVING: filters groups AFTER aggregation

-- Only count completed orders, then filter groups with more than 1
SELECT customer, COUNT(*) AS completed_orders
FROM orders
WHERE status = 'completed'          -- filters rows first, removes non-completed
GROUP BY customer
HAVING COUNT(*) > 1                 -- filters groups after, more than 1 orders
ORDER BY completed_orders DESC;

-- ⚠️  Aggregate functions are not allowed in WHERE — use HAVING for that
--
--     This is invalid:
SELECT customer FROM orders WHERE COUNT(*) > 2 GROUP BY customer; -- ❌



-- COMBINING WITH ORDER BY
-- Top spending customers (completed orders only)
SELECT
    customer,
    COUNT(*)                AS total_orders,
    SUM(amount)             AS total_spent,
    ROUND(AVG(amount), 2)   AS avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY customer
ORDER BY total_spent DESC;
