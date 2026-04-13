-- ==================
-- Topic: Data Types
-- ==================

-- ----- NUMERIC TYPES -----
CREATE TABLE IF NOT EXISTS numeric_types (
    id              SERIAL          PRIMARY KEY,  -- auto-incrementing integer, great for PKs

    regular_num     INTEGER,    -- 4 bytes (2.1B)
    small_num       SMALLINT,   -- 2 bytes (32k)
    big_num         BIGINT,     -- 8 bytes (Very large numbers)

    price           NUMERIC(10, 2),     -- exact precision, use for money (10 digits, 2 decimal)
    rating          DECIMAL(3, 1),      -- Same as NUMERIC
    temperature     REAL,               -- float4, 4 bytes, 6 decimal digits precision, allows rounding errors
    measurement     DOUBLE PRECISION    -- float8, 8 bytes, 15 decimal digits precision, still not exact
    -- RULE: use NUMERIC for money, REAL/DOUBLE only when minor rounding is acceptable
);


-- ----- TEXT TYPES -----
CREATE TABLE text_types (
    id              SERIAL          PRIMARY KEY,

    fixed_code      CHAR(5),        -- fixed length, padded with spaces if shorter (e.g. country codes)
    username        VARCHAR(50),    -- variable length with a limit
    bio             TEXT            -- unlimited length, no need to guess a limit
    -- RULE: prefer TEXT or VARCHAR; only use CHAR when length is truly fixed
);


-- ----- BOOLEAN TYPE -----
CREATE TABLE boolean_types (
    id              SERIAL          PRIMARY KEY,

    is_active       BOOLEAN,                -- TRUE / FALSE / NULL
    is_verified     BOOLEAN DEFAULT FALSE   -- always set a default for booleans
);
-- PostgreSQL accepts these as TRUE:  true, 't', 'yes', 'on', '1'
-- PostgreSQL accepts these as FALSE: false, 'f', 'no', 'off', '0'


-- ----- DATE & TIME TYPES -----
CREATE TABLE datetime_types (
    id              SERIAL          PRIMARY KEY,

    birth_date      DATE,                         -- date only: 1999-06-16
    login_time      TIME,                         -- time only: 14:30:00 (no timezone)
    login_time_tz   TIMETZ,                       -- time with timezone (rarely used)
    created_at      TIMESTAMP,                    -- date + time, no timezone
    updated_at      TIMESTAMPTZ DEFAULT NOW()     -- date + time WITH timezone — recommended default
    -- RULE: prefer TIMESTAMPTZ over TIMESTAMP so timezone is clear
);
-- Useful datetime functions:
-- SELECT NOW();                                  -- current date + time with timezone
-- SELECT CURRENT_DATE;                           -- today's date only
-- SELECT CURRENT_TIME;                           -- current time only
-- SELECT AGE(birth_date) FROM datetime_types;    -- human-readable age from a date


-- ----- JSON TYPES -----
CREATE TABLE json_types (
    id              SERIAL          PRIMARY KEY,

    raw_json        JSON,   -- stores JSON as-is, preserves whitespace & duplicates
    binary_json     JSONB   -- stores JSON in binary, indexed & faster to query
    -- RULE: always prefer JSONB over JSON unless you need to preserve exact input format
);
-- Sample insert:
-- INSERT INTO json_types (binary_json) VALUES ('{"name": "Nabil", "skills": ["python", "sql"]}');

-- Querying JSONB:
-- SELECT binary_json -> 'name'        FROM json_types;   -- returns JSON value
-- SELECT binary_json ->> 'name'       FROM json_types;   -- returns plain text value
-- SELECT binary_json -> 'skills' -> 0 FROM json_types;   -- first element of array


-- ----- ARRAY TYPE -----
CREATE TABLE array_types (
    id              SERIAL          PRIMARY KEY,
    tags            TEXT[],         -- array of text values
    scores          INTEGER[]       -- array of integers
);
-- Sample insert:
-- INSERT INTO array_types (tags, scores) VALUES (ARRAY['python', 'sql'], ARRAY[95, 87, 76]);

-- Querying arrays:
-- SELECT tags[1]          FROM array_types;      -- PostgreSQL arrays are 1-indexed!
-- SELECT * FROM array_types WHERE 'sql' = ANY(tags);


-- ----- UUID TYPE -----
CREATE TABLE uuid_types (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),  -- auto-generate UUID
    session_token   UUID
    -- Use UUID instead of SERIAL when rows may be created across multiple systems
);


-- ----- Cleanup tables after practice -----
-- DROP TABLE IF EXISTS numeric_types;
-- DROP TABLE IF EXISTS text_types;
-- DROP TABLE IF EXISTS boolean_types;
-- DROP TABLE IF EXISTS datetime_types;
-- DROP TABLE IF EXISTS json_types;
-- DROP TABLE IF EXISTS array_types;
-- DROP TABLE IF EXISTS uuid_types;
