-- ==============================
-- Topic: Create & Drop Database
-- ==============================

-- First create database
CREATE DATABASE first_db
    WITH ENCODING = 'UTF8' --character encoding
    TEMPLATE = template0; -- template0 is a "clean" template, doesn't have any user-defined objects like tables, functions, or extensions.

-- List of databases
-- SELECT datname FROM pg_database;

-- Delete database
-- DROP DATABASE IF EXISTS first_db; -- safe version
-- DROP DATABASE IF EXISTS first_db WITH (FORCE); -- force-close active connections, then delete

-- NOTE: You cannot drop a database you are currently connected to.