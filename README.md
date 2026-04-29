# 🐘 PostgreSQL Quick Reference Guide

This project is designed as a practical learning tool and a quick revision guide for anyone looking to master PostgreSQL.
Created for personal revision and open to anyone who finds it useful.


> **Note:** This repository is still a work in progress. More topics, examples and advanced concepts will be added over time!

---

## 🚀 Prerequisites

- Basic understanding of what a database is
- PostgreSQL **14+** installed ([Download](https://www.postgresql.org/download/))
- A client to run queries: `psql` (CLI), [pgAdmin](https://www.pgadmin.org/), [DBeaver](https://dbeaver.io/), or a VS Code extension like [PostgreSQL Client](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-postgresql-client2)

---

## 📂 How to Use This Repo

Each folder covers a topic. Files inside are numbered in the order you should follow them.

```bash
# Clone the repo
git clone https://github.com/nbakh16/postgresql-quick-ref.git
cd postgresql-quick-ref

# Run any file directly with psql
```
- Every file is independent. Go through any topic as needed.
- **Run every file yourself** — don't just read, execute and observe the output.
- **Modify the examples** — change values, break things, and see what happens.
- **Check the comments** — explained edge cases and exceptions, not just syntax.
---

## 🗂️ Table of Contents

| # | Topic | What You'll Learn |
|---|-------|-------------------|
| [01](./01_basics/) | **Basics** | Create/drop databases & tables, data types |
| [02](./02_crud/) | **CRUD Operations** | INSERT, SELECT, UPDATE, DELETE |
| [03](./03_query/) | **Querying** | WHERE, ORDER BY, LIMIT, aggregate functions, GROUP BY |
| [04](./04_string_date_formatting/) | **String and DateTime formatting** | String, Date & Time Formatting & Manipulation |
| ** | ..... | *New topics will be added soon!* |

---

## 📄 SQL File Structure

Every file in this repo follows this pattern so it's easy to read and re-run:

```sql
-- ============================================
-- Topic: <Topic Name>
-- Description: <What this file demonstrates>
-- ============================================

-- Setup: create any tables needed
-- ...

-- Main examples with explanatory comments
-- ...

-- Cleanup comments where necessary
-- DROP TABLE ...;
```

---

## 🤝 Contributing

Found an error? Have a better example? PRs are welcome.

1. Fork the repo
2. Create a branch: `git checkout -b add/topic-name`
3. Follow the existing file structure and comment style
4. Open a pull request with a short description

---

## 📌 Resources

- [PostgreSQL Official Docs](https://www.postgresql.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [Use The Index, Luke](https://use-the-index-luke.com/) *(indexing deep dive)*
- [pgExercises](https://pgexercises.com/) *(practice problems)*

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
