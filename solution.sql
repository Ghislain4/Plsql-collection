-- solution.sql
-- A packaged procedure (anonymous demonstration) that implements the Department Payroll Manager
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  TYPE emp_assoc_t IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
  TYPE salary_varray_t IS VARRAY(3) OF NUMBER;
  TYPE processed_tbl_t IS TABLE OF NUMBER;
  TYPE employee_rec_t IS RECORD (
    emp_id NUMBER,
    full_name VARCHAR2(120),
    salaries salary_varray_t
  );

  CURSOR c_dept IS SELECT department_id, department_name FROM departments;
  c_dept_rec c_dept%ROWTYPE;

  -- helper to fetch latest salaries into varray
  FUNCTION get_latest_salaries(p_emp_id NUMBER) RETURN salary_varray_t IS
    v_sal salary_varray_t := salary_varray_t();
    v_count NUMBER := 0;
  BEGIN
    FOR r IN (SELECT salary FROM salary_history WHERE employee_id = p_emp_id ORDER BY salary_date DESC) LOOP
      v_count := v_count + 1;
      IF v_count <= 3 THEN
        v_sal.EXTEND;
        v_sal(v_count) := r.salary;
      END IF;
    END LOOP;
    IF v_sal.COUNT = 0 THEN
      -- fallback to employees.salary
      SELECT salary INTO v_sal(1) FROM employees WHERE employee_id = p_emp_id;
    END IF;
    RETURN v_sal;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN salary_varray_t(); -- empty
  END;

  emp_rec employee_rec_t;
  processed processed_tbl_t := processed_tbl_t();
BEGIN
  OPEN c_dept;
  LOOP
    FETCH c_dept INTO c_dept_rec;
    EXIT WHEN c_dept%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('=== Department: ' || c_dept_rec.department_name || ' ===');

    FOR e IN (SELECT employee_id, first_name, last_name FROM employees WHERE department_id = c_dept_rec.department_id) LOOP
      emp_rec.emp_id := e.employee_id;
      emp_rec.full_name := e.first_name || ' ' || e.last_name;
      emp_rec.salaries := get_latest_salaries(emp_rec.emp_id);

      IF emp_rec.salaries.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  Skipping ' || emp_rec.full_name || ' (no salary data)');
        GOTO continue_dept_loop;
      END IF;

      -- compute average
      DECLARE
        v_sum NUMBER := 0;
      BEGIN
        FOR i IN 1..emp_rec.salaries.COUNT LOOP
          v_sum := v_sum + emp_rec.salaries(i);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('  ' || emp_rec.emp_id || ' | ' || emp_rec.full_name || ' | Avg: ' || TO_CHAR(v_sum/emp_rec.salaries.COUNT));
      END;

      processed.EXTEND;
      processed(processed.COUNT) := emp_rec.emp_id;

      <<continue_dept_loop>>
      NULL;
    END LOOP;

    -- Show processed (if any)
    IF processed.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('  No employees processed for this department.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('  Processed IDs count: ' || processed.COUNT);
    END IF;

    -- reset processed
    processed.DELETE;
  END LOOP;
  CLOSE c_dept;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in solution.sql: ' || SQLERRM);
END;
/
