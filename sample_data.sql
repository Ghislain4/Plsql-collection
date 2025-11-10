-- sample_data.sql
-- Insert sample departments
INSERT INTO departments (department_id, department_name) VALUES (10, 'Accounting');
INSERT INTO departments (department_id, department_name) VALUES (20, 'Sales');
INSERT INTO departments (department_id, department_name) VALUES (30, 'IT');

-- Insert employees
INSERT INTO employees (employee_id, first_name, last_name, email, department_id, hire_date, salary) VALUES (100, 'Alice', 'Ames', 'alice.ames@example.com', 10, DATE '2022-01-15', 5000);
INSERT INTO employees (employee_id, first_name, last_name, email, department_id, hire_date, salary) VALUES (101, 'Bob', 'Baker', 'bob.baker@example.com', 10, DATE '2021-06-10', 5200);
INSERT INTO employees (employee_id, first_name, last_name, email, department_id, hire_date, salary) VALUES (102, 'Carol', 'Clark', 'carol.clark@example.com', 20, DATE '2020-03-20', 6000);
INSERT INTO employees (employee_id, first_name, last_name, email, department_id, hire_date, salary) VALUES (103, 'David', 'Dawson', 'david.dawson@example.com', 30, DATE '2019-11-05', 7000);
INSERT INTO employees (employee_id, first_name, last_name, email, department_id, hire_date, salary) VALUES (104, 'Eve', 'Evans', 'eve.evans@example.com', 20, DATE '2023-02-01', NULL);

-- Insert salary history (latest 3 salaries per employee where possible)
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (100, 4800, DATE '2024-08-01');
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (100, 4900, DATE '2024-09-01');
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (100, 5000, DATE '2024-10-01');

INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (101, 5100, DATE '2024-09-01');
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (101, 5200, DATE '2024-10-01');

INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (102, 5800, DATE '2024-08-01');
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (102, 5900, DATE '2024-09-01');
INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (102, 6000, DATE '2024-10-01');

INSERT INTO salary_history (employee_id, salary, salary_date) VALUES (103, 6800, DATE '2024-10-01');

COMMIT;
