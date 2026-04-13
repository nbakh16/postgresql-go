-- ==============================
-- Topic: Constraints & Defaults
-- ==============================

CREATE TABLE demo_table(
    id          SERIAL          PRIMARY KEY,                -- auto-incrementing integer
    username    VARCHAR(50)     NOT NULL,                   -- required field validation
    email       VARCHAR(50)     UNIQUE NOT NULL,            -- unique field validation
    age         INTEGER         NOT NULL CHECK (age>=18),   -- Condition validation
    user_role   VARCHAR(20)     DEFAULT 'User',             -- default value
    created_at  TIMESTAMPTZ     DEFAULT NOW(),              -- current date-time as default
    profile     JSONB           DEFAULT '{}'::JSONB,        -- empty json as default
    tags        TEXT[]          DEFAULT ARRAY[]::TEXT[]
);

-- NOTES:
-- NOT NULL: rejects missing values entirely
-- UNIQUE: rejects duplicate values (NULLs are treated as distinct — two NULLs are allowed)
-- CHECK: rejects values that fail the condition
-- DEFAULT: used only on INSERT when no value is provided; ignored on UPDATE


-- Verify constraints are working:
-- INSERT INTO demo_table (username, email, age) VALUES ('nabil', 'nbakh16@email.com', 28);     -- ✅ works
-- INSERT INTO demo_table (username, email, age) VALUES ('akhunjee', 'nbakh16@email.com', 28);  -- ❌ UNIQUE violation
-- INSERT INTO demo_table (username, email, age) VALUES ('nabil', 'akhunjee97@email.com', 16);  -- ❌ CHECK violation
-- INSERT INTO demo_table (username, email, age) VALUES (NULL, 'nbakhunjee97@email.com', 28);   -- ❌ NOT NULL violation

-- SELECT * FROM demo_table
