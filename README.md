# PL/SQL Collections, Records, and GOTO — Repository

**Course:** Database development with PL/SQL (INSY 831)  
**Author:** Generated for student assignment  
**Date:** 2025-11-10

## Overview
This repository contains:
- A clear **problem statement** that requires using PL/SQL Collections (Associative Arrays, VARRAYs, Nested Tables), Records (table-based, user-defined, cursor-based), and **GOTO** statements.
- SQL scripts to **create sample tables** and populate test data.
- PL/SQL scripts with **worked examples** and a final solution for the problem.
- Documentation and an **assessment checklist** your instructor can use.

## Files
- `problem_statement.md` — problem description and requirements
- `sql/create_tables.sql` — DDL to create `departments` and `employees` tables
- `sql/sample_data.sql` — sample data for testing
- `plsql/examples.sql` — multiple PL/SQL anonymous blocks demonstrating features
- `plsql/solution.sql` — a packaged solution (procedure) solving the problem
- `docs/README.md` — usage & testing instructions
- `assessment_checklist.md` — rubric and checklist for next week's assessment

## How to use
1. Run `sql/create_tables.sql` in Oracle SQL*Plus/SQL Developer to create schema objects.
2. Run `sql/sample_data.sql` to insert sample rows.
3. Execute `plsql/examples.sql` to see demonstrations in DBMS_OUTPUT.
4. Run `plsql/solution.sql` (it contains an executable anonymous block with tests).
