# Problem Statement — Department Payroll Manager

## Goal
Design and implement a PL/SQL solution that demonstrates the use of:
- **Collections**: Associative arrays, VARRAYs, Nested Tables
- **Records**: Table-based (%ROWTYPE), User-defined RECORD types, Cursor-based records
- **GOTO** statements and labeled blocks (used sensibly)

Build a small feature called **Department Payroll Manager** with these capabilities:
1. Load all employees for a given department into an **associative array** keyed by employee email.
2. For each employee, collect their latest 3 monthly salaries into a **VARRAY** stored in a user-defined record.
3. Maintain a **nested table** of processed employee IDs (to demonstrate sparse behavior and DELETE).
4. Use a **cursor-based record** to iterate over departments.
5. Use a **GOTO** label to skip an employee when certain validation fails (e.g., salary is NULL or zero).
6. Produce an output summary (via DBMS_OUTPUT) that lists:
   - Department name
   - Number of employees processed
   - For each employee: employee_id, full name, salaries (comma-separated), average salary
7. Include error handling and comments explaining each construct.

Deliverables:
- PL/SQL code that runs in Oracle (SQL*Plus or SQL Developer).
- Documentation explaining how each PL/SQL construct is used and why.
- A short test plan and expected output for verification.

Constraints:
- The VARRAY size for latest salaries is fixed to 3.
- Use at least one associative array, one varray, one nested table, one user-defined record, and one goto label.
