-- ============================================
-- Topic: String Formatting & Manipulation
-- Description: Case, length, trimming, padding,
--              searching, substring, replace,
--              concate, split, reverse, template formate
-- ============================================

-- Setup
-- Create Table and Manipulate data
CREATE TABLE users (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    rank        VARCHAR(50)     DEFAULT 'newbie',
    email       VARCHAR(50),
    bio         TEXT
);

INSERT INTO users (name, rank, email, bio)
VALUES
    ('    Mr Rahim      ', 'Newbie', 'rahim@company.com', 'Loves clean code and coffee.'),
    ('Karim Rahman', 'Gold', 'KARIM@COMPANY.COM', 'Building products people love.'),
    ('Sadia Israt', 'Newbie', 'Israt@company.com', 'Design is how it works.'),
    ('Faruk Ahmed', 'Platinum', 'faruk@company.com', 'Numbers tell stories.'),
    ('Ms Nasreen', 'Gold', 'nasreen@company.com', 'Have a nice and lovely day.');



--⭐ ----- CASE CONVERSION -----
SELECT
    name,
    LOWER(name)     AS lower_name,  -- all lowercase
    UPPER(name)     AS upper_name,  -- all uppercase
    INITCAP(name)   AS title_case   -- First Letter Of Each Word Capitalised
FROM users;

-- Practical use: normalise data before comparison
SELECT * FROM users WHERE LOWER(rank) = 'gold';



--⭐ ----- LENGTH & CHARACTER INFO -----
SELECT
    name,
    LENGTH(name)        AS char_length,     -- number of characters (counts spaces too)
    CHAR_LENGTH(name)   AS char_length_alt, -- same as LENGTH
    OCTET_LENGTH(name)  AS byte_length      -- number of bytes (differs for multibyte/UTF-8 chars)
FROM users;



--⭐ ----- TRIMMING WHITESPACE -----
-- Notice '    Mr Rahim      ' has leading and trailing spaces
SELECT
    name,
    TRIM(name)      AS trim_both,   -- removes leading and trailing spaces
    LTRIM(name)     AS trim_left,   -- removes leading spaces only
    RTRIM(name)     AS trim_right   -- removes trailing spaces only
FROM users;

-- TRIM can also remove specific characters
SELECT TRIM(BOTH 'x' FROM 'xxxHelloxxx');  -- -> 'Hello'
SELECT TRIM(LEADING '0' FROM '000123');     -- -> '123' (useful for cleaning zero-padded IDs)



--⭐ ----- PADDING -----
SELECT
    LPAD('42', 6, '0')      AS left_padded,     -- -> '000042' (pad left to length 6 with '0')
    RPAD('hello', 8, '.')   AS right_padded;     -- -> 'hello...' (pad right to length 8 with '.')

-- Practical use: formatting invoice numbers, fixed-width exports
SELECT LPAD(id::TEXT, 6, '0') AS invoice_number FROM users; --all user ids to 6 character length



--⭐ ----- SEARCHING WITHIN STRINGS -----
SELECT
    name,
    POSITION('a' IN LOWER(name))    AS first_a_at,      -- position of first 'a' (1-indexed, counts spaces)
    STRPOS(LOWER(name), 'a')        AS first_a_strpos,  -- same as POSITION, different syntax
    LEFT(name, 5)                   AS first_5_chars,   -- first N characters
    RIGHT(name, 5)                  AS last_5_chars     -- last N characters
FROM users;



--⭐ ----- SUBSTRING — EXTRACT PART OF A STRING -----
SELECT
    email,
    SUBSTRING(email FROM 1 FOR 5)                           AS first_5,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1)  AS username, -- first part of email as username
    SUBSTRING(email FROM POSITION('@' IN email) + 1)        AS domain   -- extract domain from email
FROM users;

-- SUBSTRING also supports regex patterns
SELECT SUBSTRING('Order #12345 placed' FROM '[0-9]+') AS order_number;  -- → '12345'



--⭐ ----- REPLACE & TRANSLATE -----
SELECT
    name,
    REPLACE(name, ' ', '_')        AS underscored,         -- replace all spaces with underscores
    REPLACE(email, '@company.com', '') AS username_from_email  -- strip domain from email
FROM users;



--⭐ ----- SPLITTING STRINGS -----
-- SPLIT_PART: extract a segment by delimiter and position
SELECT
    email,
    SPLIT_PART(email, '@', 1)   AS username,    -- part before @
    SPLIT_PART(email, '@', 2)   AS domain       -- part after @
FROM users;

-- STRING_TO_ARRAY: convert delimited string into an array
SELECT STRING_TO_ARRAY(email, '@') 
FROM users;



--⭐ ----- CONCATENATION -----
SELECT
    CONCAT(name, ' — ', rank)            AS name_role,       -- CONCAT ignores NULLs
    name || ' — ' || rank                AS name_role_alt,   -- || operator; propagates NULLs
    CONCAT_WS(' | ', name, rank, email)  AS pipe_separated   -- CONCAT_WS joins with separator, skips NULLs
FROM users;

-- NOTE:  || returns NULL if any part is NULL — use CONCAT or CONCAT_WS when NULLs are possible



--⭐ ----- REVERSE -----
SELECT name, REVERSE(name) AS reversed FROM users;
-- Practical use: checking palindromes, reversing sort keys



--⭐ ----- FORMAT — TEMPLATE-STYLE STRING BUILDING -----
SELECT FORMAT('User: %s | Rank: %s | Email: %s', name, rank, email)
AS summary
FROM users;
-- FORMAT is cleaner than chaining CONCAT for complex strings
-- %s = string,
-- %I = identifier (quoted), 
-- %L = literal (quoted for SQL)
