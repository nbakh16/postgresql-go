-- ============================================
-- Topic: LIMIT & OFFSET — Pagination
-- Description: Result size, skipping rows, pagination,
--              performance for pagination
-- ============================================


-- Setup
-- Create table and manipulate data
CREATE TABLE books (
    id          SERIAL          PRIMARY KEY,
    title       VARCHAR(100)    NOT NULL,
    author      VARCHAR(100)    NOT NULL,
    views       INTEGER         DEFAULT 0,
    published_at DATE           DEFAULT CURRENT_DATE
);

INSERT INTO books (title, author, views, published_at)
VALUES
    ('To Kill a Mockingbird', 'Harper Lee', 400, '1960-07-11'),
    ('1984', 'George Orwell', 380, '1949-06-08'),
    ('The Great Gatsby', 'F. Scott Fitzgerald', 350, '1925-04-10'),
    ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 725, '1997-06-26'),
    ('The Alchemist', 'Paulo Coelho', 420, '1988-05-01'),
    ('Atomic Habits', 'James Clear', 450, '2018-10-16'),
    ('The 7 Habits of Highly Effective People', 'Stephen R. Covey', 470, '1989-08-15'),
    ('How to Win Friends & Influence People', 'Dale Carnegie', 430, '1936-10-01'),
    ('Thinking, Fast and Slow', 'Daniel Kahneman', 201, '2011-10-25'),
    ('The Silent Patient', 'Alex Michaelides', 320, '2019-02-05'),
    ('Where the Crawdads Sing', 'Delia Owens', 340, '2018-08-14'),
    ('Pride and Prejudice', 'Jane Austen', 500, '1813-01-28'),
    ('Moby-Dick', 'Herman Melville', 450, '1851-10-18'),
    ('Jane Eyre', 'Charlotte Brontë', 400, '1847-10-16'),
    ('Wuthering Heights', 'Emily Brontë', 420, '1847-12-01'),
    ('Great Expectations', 'Charles Dickens', 480, '1861-08-01');



--⭐ ----- LIMIT — RESTRICT RESULT SIZE -----
SELECT * FROM books LIMIT 5;    -- return first 5 rows only
SELECT * FROM books ORDER BY views DESC LIMIT 3;    -- top 3 most viewed books
SELECT * FROM books ORDER BY published_at DESC LIMIT 3; -- latest published 3 books



--⭐ ----- OFFSET — SKIP ROWS -----
-- Skip the first 5 rows and return the rest
SELECT * FROM books OFFSET 5;

-- Skip first 3 most-viewed, return next 3 (ranks 4–6)
SELECT * FROM books ORDER BY views DESC LIMIT 3 OFFSET 3;

-- NOTE: OFFSET without ORDER BY is meaningless.
-- Row order is not guaranteed without ORDER BY.



--⭐ ----- PAGINATION PATTERN -----
-- Standard formula: OFFSET = (page_number - 1) * page_size
SELECT id, title, author FROM books 
    ORDER BY published_at DESC LIMIT 5 OFFSET 0;    -- Page 1 — first 5 books
SELECT id, title, author FROM books 
    ORDER BY published_at DESC LIMIT 5 OFFSET 5;    -- Page 2 — next 5 books
SELECT id, title, author FROM books 
    ORDER BY published_at DESC LIMIT 5 OFFSET 10;    -- Page 3 — next 5 books



--⭐ ----- COUNT TOTAL FOR PAGINATION UI -----
-- Frontend pagination needs total row count to calculate total pages
SELECT COUNT(*) AS total_books FROM books;
-- total_pages = CEIL(total_books / page_size)
-- CEIL is used to round a number up to the nearest integer

SELECT 
    total_books,
    CEIL(total_books::numeric / 5) AS total_pages
FROM (
    SELECT COUNT(*) AS total_books
    FROM books
);

-- PERFORMANCE NOTE
-- ⚠️  OFFSET gets slower as it grows — PostgreSQL must scan and discard
--     all rows before the offset value on every query.
--     For page 1000 with page_size 20, PostgreSQL scans 20,000 rows just to skip them.

-- ✅ For large datasets, prefer KEYSET (cursor-based) pagination:
--    Instead of OFFSET, filter by the last seen ID or timestamp

-- Slower (offset-based):
-- SELECT * FROM books ORDER BY id ASC LIMIT 4 OFFSET 10000;

-- Faster (keyset-based) — continue from where you left off:
-- SELECT * FROM books WHERE id > 10000 ORDER BY id ASC LIMIT 4;



--⭐ ----- FETCH — SQL STANDARD ALTERNATIVE -----
-- FETCH is the SQL standard syntax — functionally identical to LIMIT/OFFSET
SELECT title, views FROM books ORDER BY views DESC
FETCH FIRST 5 ROWS ONLY;

-- With offset
SELECT title, views FROM books ORDER BY views DESC
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY;

-- LIMIT/OFFSET is more commonly used in PostgreSQL.
-- FETCH is more portable across databases
