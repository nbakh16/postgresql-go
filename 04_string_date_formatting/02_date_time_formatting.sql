-- ============================================
-- Topic: Date & Time Foramatting & Manipulation
-- Description: Current date/time, extraction,
--              arithmetic, formatting, truncation,
--              intervals, timezone handling,
--              MAKE_DATE, MAKE_TIMESTAMP
-- ============================================

-- Setup
-- Create table and Manipulate data
-- drop employees table if exist already
CREATE TABLE employees (
    id              SERIAL          PRIMARY KEY,
    name            VARCHAR(50)     NOT NULL,
    birth_date      DATE            NOT NULL,
    joined_at       DATE            NOT NULL,
    last_login      TIMESTAMPTZ,
    shift_start     TIME
);

INSERT INTO employees (name, birth_date, joined_at, last_login, shift_start)
VALUES
    ('Mr Rahim',        '1990-03-15',   '2019-06-01',   '2024-11-20 09:15:00+06',   '09:00:00'),
    ('Sadia Israt',     '1985-11-22',   '2021-02-14',   '2024-11-19 17:42:00+06',   '08:30:00'),
    ('Faruk Ahmed',     '1993-07-08',   '2018-09-30',   '2024-11-21 11:05:00+06',   '10:00:00'),
    ('Karim Rahman',    '1998-01-30',   '2023-03-20',   '2024-10-31 08:00:00+06',   '08:00:00'),
    ('Ms Nasreen',      '1991-05-19',   '2020-11-05',   '2024-11-18 14:30:00+06',   '09:30:00');



--⭐ ----- CURRENT DATE & TIME -----
SELECT
    NOW()               AS now_with_tz,         -- current timestamp with timezone
    CURRENT_TIMESTAMP   AS current_ts,          -- same as NOW(), SQL standard syntax
    CURRENT_DATE        AS today,               -- date only, no time
    CURRENT_TIME        AS time_now,            -- time only with timezone
    LOCALTIME           AS local_time,          -- time without timezone
    LOCALTIMESTAMP      AS local_timestamp;     -- timestamp without timezone

-- NOTE: NOW() returns the same value for the entire transaction
--      Use CLOCK_TIMESTAMP() if you need the real current time mid-transaction
-- NOW() = consistent timestamp for the whole transaction
-- CLOCK_TIMESTAMP() = real-time clock



--⭐ ----- EXTRACTING PARTS FROM A DATE -----
SELECT
    name,
    joined_at,
    EXTRACT(YEAR  FROM joined_at)   AS join_year,
    EXTRACT(MONTH FROM joined_at)   AS join_month,
    EXTRACT(DAY   FROM joined_at)   AS join_day,
    EXTRACT(DOW   FROM joined_at)   AS day_of_week, -- 0 = Sunday, 6 = Saturday
    EXTRACT(DOY   FROM joined_at)   AS day_of_year, -- 1–366
    EXTRACT(WEEK  FROM joined_at)   AS week_number,
    EXTRACT(QUARTER FROM joined_at) AS quarter      -- 1–4
FROM employees;

-- DATE_PART is the older equivalent of EXTRACT — same result, different syntax
SELECT DATE_PART('year', joined_at) AS join_year FROM employees;



--⭐ ----- FORMATTING DATES -----
SELECT
    name,
    joined_at,
    TO_CHAR(joined_at, 'DD Mon YYYY')           AS formatted,   -- '01 Jun 2019'
    TO_CHAR(joined_at, 'Day, DD Month YYYY')    AS verbose,     -- 'Saturday, 01 June 2019'
    TO_CHAR(joined_at, 'MM/DD/YYYY')            AS us_format,   -- '06/01/2019'
    TO_CHAR(joined_at, 'YYYY-MM-DD')            AS iso_format,  -- '2019-06-01'
    TO_CHAR(last_login, 'HH12:MI AM')           AS time_12hr,   -- '09:15 AM'
    TO_CHAR(last_login, 'HH24:MI:SS')           AS time_24hr    -- '09:15:00'
FROM employees;

-- Common TO_CHAR format tokens:
-- YYYY = 4-digit year     MM = month number     DD = day number
-- Mon  = abbreviated month (Jan)   Month = full month name
-- Day  = full day name    HH12/HH24 = hour    MI = minutes   SS = seconds



--⭐ ----- PARSING STRINGS INTO DATES -----
-- TO_DATE: parse a string into a DATE
SELECT TO_DATE('16 Jun 1999', 'DD Mon YYYY');   -- 1999-06-16
SELECT TO_DATE('1999/06/16', 'YYYY/MM/DD');     -- 1999-06-16

-- TO_TIMESTAMP: parse a string into a TIMESTAMPTZ
SELECT TO_TIMESTAMP('1999-06-16 09:15:00', 'YYYY-MM-DD HH24:MI:SS');



--⭐ ----- DATE ARITHMETIC -----
SELECT
    name,
    joined_at,
    joined_at + INTERVAL '30 days'      AS plus_30_days,
    joined_at - INTERVAL '1 year'       AS minus_1_year,
    joined_at + INTERVAL '3 months'     AS plus_3_months,
    CURRENT_DATE - joined_at            AS days_since_joining   -- returns an integer (number of days)
FROM employees;

-- INTERVAL supports many units
SELECT
    NOW() + INTERVAL '2 hours 30 minutes'   AS in_2h30m,
    NOW() - INTERVAL '1 week'               AS one_week_ago,
    NOW() + INTERVAL '1 year 6 months'      AS in_18_months;



--⭐ ----- DATE DIFFERENCE & AGE -----
SELECT
    name,
    birth_date,
    AGE(birth_date)                     AS age,             -- 40 years 4 months ...
    AGE(CURRENT_DATE, birth_date)       AS age_explicit,    -- same, explicit second argument
    EXTRACT(YEAR FROM AGE(birth_date))  AS age_in_years,    -- just the year number
    CURRENT_DATE - birth_date           AS age_in_days,
    joined_at,
    AGE(joined_at)                      AS tenure,          -- how long they've worked here
    EXTRACT(YEAR FROM AGE(joined_at))   AS years_at_company
FROM employees;



--⭐ ----- DATE TRUNCATION -----
-- DATE_TRUNC rounds a timestamp DOWN to the specified unit
-- Useful for grouping by month, quarter, week etc.
SELECT
    last_login,
    DATE_TRUNC('year',  last_login) AS trunc_year,  -- 2024-01-01 00:00:00
    DATE_TRUNC('month', last_login) AS trunc_month, -- 2024-11-01 00:00:00
    DATE_TRUNC('week',  last_login) AS trunc_week,  -- Monday of that week
    DATE_TRUNC('day',   last_login) AS trunc_day,   -- 2024-11-20 00:00:00
    DATE_TRUNC('hour',  last_login) AS trunc_hour   -- 2024-11-20 09:00:00
FROM employees;

-- Practical use: count logins per month
-- SELECT DATE_TRUNC('month', last_login) AS month, COUNT(*) AS logins
-- FROM employees
-- GROUP BY DATE_TRUNC('month', last_login)
-- ORDER BY month;



--⭐ ----- DAY / MONTH / YEAR SHORTCUTS -----
-- These are shorthand alternatives to EXTRACT
SELECT
    name,
    joined_at,
    DATE_PART('year',   joined_at)  AS year,
    DATE_PART('month',  joined_at)  AS month,
    DATE_PART('day',    joined_at)  AS day
FROM employees;



--⭐ ----- CHECKING DATE RANGES -----
-- Employees who joined in 2021
SELECT * FROM employees 
WHERE joined_at BETWEEN '2021-01-01' AND '2021-12-31';



--⭐ ----- TIMEZONE HANDLING -----
-- View current timezone setting
SHOW timezone;

-- Convert a TIMESTAMPTZ to another timezone
SELECT
    name,
    last_login                                  AS stored_utc,
    last_login AT TIME ZONE 'UTC'               AS utc,
    last_login AT TIME ZONE 'Asia/Dhaka'        AS dhaka_time,
    last_login AT TIME ZONE 'America/New_York'  AS new_york_time
FROM employees;

-- NOTE: TIMESTAMPTZ stores in UTC internally and converts on display
--     TIMESTAMP (without TZ) stores exactly what you give it — no conversion, no awareness
--     Always prefer TIMESTAMPTZ for any real-world application



--⭐ ----- MAKE_DATE / MAKE_TIMESTAMP — BUILD FROM PARTS -----
-- Construct a date from year, month, day integers
SELECT MAKE_DATE(1999, 06, 16);                 -- 1999-06-16
SELECT MAKE_TIMESTAMP(1999, 06, 16, 9, 15, 0);  -- 1999-06-16 09:15:00

-- Practical use: build a date from extracted parts or user inputs
SELECT MAKE_DATE(
    EXTRACT(YEAR  FROM CURRENT_DATE)::INT,
    EXTRACT(MONTH FROM CURRENT_DATE)::INT,
    1
) AS first_of_current_month;
