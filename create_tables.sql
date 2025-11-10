-- create_tables.sql
-- Creates departments and employees for demo purposes

CREATE TABLE departments (
  department_id NUMBER PRIMARY KEY,
  department_name VARCHAR2(100)
);

CREATE TABLE employees (
  employee_id NUMBER PRIMARY KEY,
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  email VARCHAR2(100) UNIQUE,
  department_id NUMBER,
  hire_date DATE,
  -- Simulate monthly salary value; in real schema you'd have a salary_history table
  salary NUMBER
);

-- Optional: a simple salary_history table for realistic latest-salaries scenario
CREATE TABLE salary_history (
  hist_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  employee_id NUMBER,
  salary NUMBER,
  salary_date DATE
);
