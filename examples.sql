-- examples.sql
-- Demonstrations of Collections, Records and GOTO

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  -- 1) Associative array indexed by email -> store employee_id
  TYPE emp_assoc_t IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
  emp_by_email emp_assoc_t;

  -- 2) VARRAY type for latest 3 salaries
  TYPE salary_varray_t IS VARRAY(3) OF NUMBER;

  -- 3) Nested table of processed employee IDs
  TYPE processed_tbl_t IS TABLE OF NUMBER;
  processed processed_tbl_t := processed_tbl_t();

  -- 4) User-defined record (holds basic info plus VARRAY)
  TYPE employee_rec_t IS RECORD (
    emp_id NUMBER,
    full_name VARCHAR2(120),
    salaries salary_varray_t
  );

  -- 5) Cursor for departments and cursor-based record
  CURSOR c_dept IS SELECT department_id, department_name FROM departments;
  c_dept_rec c_dept%ROWTYPE;

  -- working variables
  emp_rec employee_rec_t;
  avg_salary NUMBER;
  cnt_dept NUMBER := 0;
BEGIN
  -- Populate associative array from employees table
  FOR r IN (SELECT employee_id, email FROM employees) LOOP
    emp_by_email(r.email) := r.employee_id;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Demonstration: associative array contents (email => id) ---');
  FOR i IN emp_by_email.FIRST .. emp_by_email.LAST LOOP
    NULL; -- cannot iterate numeric bounds safely for string keys; iterate via keys differently
  END LOOP;

  -- Better: iterate using a cursor over keys (use pairwise SELECT)
  FOR r IN (SELECT email, employee_id FROM employees) LOOP
    DBMS_OUTPUT.PUT_LINE('Email: ' || r.email || ' => ID: ' || r.employee_id);
  END LOOP;

  -- Process each department using a cursor-based record
  OPEN c_dept;
  LOOP
    FETCH c_dept INTO c_dept_rec;
    EXIT WHEN c_dept%NOTFOUND;
    cnt_dept := cnt_dept + 1;
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Department: ' || c_dept_rec.department_name);

    -- reset processed nested table
    processed.DELETE;
    -- get employees for this department into associative array (re-using structure)
    FOR e IN (SELECT employee_id, first_name, last_name, email FROM employees WHERE department_id = c_dept_rec.department_id) LOOP
      -- Initialize employee record
      emp_rec.emp_id := e.employee_id;
      emp_rec.full_name := e.first_name || ' ' || e.last_name;

      -- Fetch latest up to 3 salary entries from salary_history (simulated)
      emp_rec.salaries := salary_varray_t(); -- initialize
      DECLARE
        CURSOR c_sal IS
          SELECT salary FROM salary_history
          WHERE employee_id = emp_rec.emp_id
          ORDER BY salary_date DESC;
        v_sal salary_varray_t := salary_varray_t();
        v_count NUMBER := 0;
      BEGIN
        FOR s IN c_sal LOOP
          v_count := v_count + 1;
          IF v_count <= 3 THEN
            v_sal.EXTEND;
            v_sal(v_count) := s.salary;
          END IF;
        END LOOP;
        -- If no salary_history rows, try employee.salary column
        IF v_sal.COUNT = 0 THEN
          IF (SELECT salary FROM employees WHERE employee_id = emp_rec.emp_id) IS NOT NULL THEN
            v_sal.EXTEND;
            v_sal(1) := (SELECT salary FROM employees WHERE employee_id = emp_rec.emp_id);
          END IF;
        END IF;
        emp_rec.salaries := v_sal;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- nothing
      END;

      -- Example usage of GOTO: skip employees with NULL or zero salary
      IF emp_rec.salaries.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  Skipping ' || emp_rec.full_name || ' (no salary info)');
        GOTO skip_employee;
      END IF;

      -- Compute average salary
      avg_salary := 0;
      FOR i IN 1..emp_rec.salaries.COUNT LOOP
        avg_salary := avg_salary + emp_rec.salaries(i);
      END LOOP;
      avg_salary := avg_salary / emp_rec.salaries.COUNT;

      -- Append to processed nested table (demonstrates EXTEND and sparse behavior)
      processed.EXTEND;
      processed(processed.COUNT) := emp_rec.emp_id;

      -- Output employee summary
      DBMS_OUTPUT.PUT_LINE('  Employee: ' || emp_rec.emp_id || ' - ' || emp_rec.full_name);
      DBMS_OUTPUT.PUT_LINE('    Salaries: ' || 
         (CASE WHEN emp_rec.salaries.COUNT > 0 
           THEN TO_CHAR(emp_rec.salaries(1)) || NVL2(emp_rec.salaries(2), ', '||TO_CHAR(emp_rec.salaries(2)), '') || NVL2(emp_rec.salaries(3), ', '||TO_CHAR(emp_rec.salaries(3)), '')
           ELSE 'None' END));
      DBMS_OUTPUT.PUT_LINE('    Average Salary: ' || TO_CHAR(avg_salary));

      <<skip_employee>>
      NULL; -- label target - continue loop (GOTO jumps here when skipping)
    END LOOP; -- end employees loop

    -- Demonstrate nested table sparse behaviour (delete the second element if exists)
    IF processed.COUNT >= 2 THEN
      processed.DELETE(2); -- create a gap
    END IF;

    -- Show processed IDs (checking EXISTS)
    DBMS_OUTPUT.PUT_LINE('  Processed employee IDs (checking EXISTS):');
    FOR idx IN 1..NVL(processed.LAST,0) LOOP
      IF processed.EXISTS(idx) THEN
        DBMS_OUTPUT.PUT_LINE('    idx='||idx||' id='||processed(idx));
      ELSE
        DBMS_OUTPUT.PUT_LINE('    idx='||idx||' <deleted>');
      END IF;
    END LOOP;

  END LOOP;
  CLOSE c_dept;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in examples.sql: ' || SQLERRM);
END;
/
