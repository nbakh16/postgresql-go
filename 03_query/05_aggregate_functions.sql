-- ============================================
-- Topic: Aggregate Functions
-- Description: COUNT, SUM, AVG, MIN, MAX,
--              aggregating with DISTINCT,
--              FILTER clause
-- ============================================

-- Setup
CREATE TABLE orders (
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



--⭐ ----- COUNT -----
SELECT COUNT(*)         AS total_orders      FROM orders;   -- counts all rows including NULLs
SELECT COUNT(status)    AS non_null_status   FROM orders;   -- counts only non-NULL values
SELECT COUNT(DISTINCT customer) AS unique_customers FROM orders;    -- counts unique values only

-- COUNT(*) never ignores NULLs,
-- COUNT(column) skips rows where that column is NULL



--⭐ ----- SUM -----
SELECT SUM(amount)              AS total_revenue     FROM orders;
SELECT SUM(amount * quantity)   AS total_value       FROM orders;
SELECT SUM(amount)              AS completed_revenue FROM orders WHERE status = 'completed';



--⭐ ----- AVG -----
SELECT AVG(amount)              AS avg_order_amount  FROM orders;
SELECT ROUND(AVG(amount), 2)    AS avg_rounded       FROM orders;    -- round to 2 decimal places



--⭐ ----- MIN & MAX -----
SELECT MIN(amount)      AS cheapest_order    FROM orders;
SELECT MIN(created_at)  AS first_order_date  FROM orders;
SELECT MAX(created_at)  AS latest_order_date FROM orders;

-- Both together
SELECT
    MIN(amount)     AS min_order,
    MAX(amount)     AS max_order,
    MAX(amount) - MIN(amount) AS price_range
FROM orders;



--⭐ ----- COMBINING AGGREGATES -----
SELECT
    COUNT(*)                AS total_orders,
    COUNT(DISTINCT customer)AS unique_customers,
    SUM(amount)             AS total_revenue,
    ROUND(AVG(amount), 2)   AS avg_order_value,
    MIN(amount)             AS smallest_order,
    MAX(amount)             AS largest_order
FROM orders
WHERE status = 'completed';



--⭐ ----- FILTER CLAUSE -----
-- Aggregate different subsets in a single query — cleaner than multiple queries
SELECT
    COUNT(*)                                        AS total_orders,
    COUNT(*) FILTER (WHERE status = 'completed')    AS completed,
    COUNT(*) FILTER (WHERE status = 'cancelled')    AS cancelled,
    COUNT(*) FILTER (WHERE status = 'pending')      AS pending,
    AVG(amount) FILTER (WHERE status = 'completed') AS avg_completed
FROM orders;


-- NULL BEHAVIOUR IN AGGREGATES
-- All aggregate functions (SUM, AVG, MIN, MAX) ignore NULL values automatically
-- COUNT(*) includes NULLs; COUNT(column) excludes them
