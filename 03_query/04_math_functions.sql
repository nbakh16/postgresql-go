-- ============================================
-- Topic: Mathematical Functions & Operators
-- Description: Arithmetic operations, percentages, 
--              rounding, and advanced math functions
-- ============================================

-- Setup
-- Create table and manipulate data
CREATE TABLE product_pricing (
    id              SERIAL          PRIMARY KEY,
    product_name    VARCHAR(100)    NOT NULL,
    base_price      NUMERIC(10, 2)  NOT NULL,
    discount_pct    NUMERIC(5, 2)   DEFAULT 0.00, -- e.g., 15.00 for 15%
    tax_rate        NUMERIC(5, 4)   DEFAULT 0.00, -- e.g., 0.0850 for 8.5%
    shipping_vol    INTEGER         NOT NULL      -- used for volume calculations
);

INSERT INTO product_pricing (product_name, base_price, discount_pct, tax_rate, shipping_vol)
VALUES
    ('Laptop Pro',      90000,  10.00,  0.0800, 64),
    ('Wireless Mouse',  3000,   0.00,   0.0525, 8),
    ('Standing Desk',   18000,  15.00,  0.1000, 512),
    ('Monitor 27"',     29000,  0.00,   0.0500, 27),
    ('Ergonomic Chair', 15000,  25.00,  0.1500, 1000);



--⭐ ----- BASIC ARITHMETIC: +, -, *, / -----
SELECT 
    product_name,
    base_price,
    base_price + 90.00 AS price_plus_markup,
    base_price - 1000.00 AS price_dicount_coupon,
    base_price * 2     AS double_price,
    base_price / 2     AS half_price
FROM product_pricing;

-- NOTE: INTEGER DIVISION TRAP
-- dividing two integers results in an integer (truncates the decimal).
SELECT 
    1 / 2 AS int_division,              -- Returns 0
    1::NUMERIC / 2 AS numeric_division, -- Returns 0.500...
    1.0 / 2 AS literal_division;        -- Returns 0.500...



--⭐ ----- PERCENTAGE INCREASE & TAX DEDUCTION -----
-- 1. Percentage Increase, Formula: base * (1 + rate)
-- 2. Tax Deduction / Discount, Formula: base - (base * (discount_pct / 100))
-- 3. Combined: Discount first, then apply tax
SELECT 
    product_name,
    base_price,
    /*1.*/ base_price * (1 + tax_rate) AS price_with_tax,    
    /*2.*/ base_price - (base_price * (discount_pct / 100.0)) AS price_after_discount,
    /*3.*/ (base_price - (base_price * (discount_pct / 100.0))) * (1 + tax_rate) AS final_checkout_price
FROM product_pricing;



--⭐ ----- ROUNDING: ROUND, CEIL, FLOOR -----
-- ROUND(value, decimal_places) -> Rounds to nearest mathematically
-- CEIL(value) or CEILING(value) -> Always rounds UP to the nearest integer
-- FLOOR(value) -> Always rounds DOWN to the nearest integer
SELECT
    ROUND(4.4, 2) AS rounded_price,
    CEIL(4.4) AS ceiling_price,
    FLOOR(4.4) AS floor_price;



--⭐ ----- POWER AND SQUARE ROOT (SQRT) -----
-- POWER(base, exponent). Useful for compound interest or geometric scaling
-- PostgreSQL also supports the '^' operator for exponentiation (returns double precision)
-- SQRT(value) -> Square Root
--      Example: Finding the 1D length of a side if the volume was a 2D square area
SELECT 
    product_name,
    shipping_vol,
    POWER(shipping_vol, 2) AS volume_squared,   -- POWER(base, exponent)
    shipping_vol ^ 3 AS volume_cubed,
    ROUND(SQRT(shipping_vol)::NUMERIC, 2) AS root_of_volume
FROM product_pricing;

-- NOTE: POWER/SQRT Return Types
-- Mathematical functions like POWER and SQRT often return DOUBLE PRECISION (floating point).
-- If you need exact financial math, cast them back to NUMERIC as shown above (::NUMERIC).
