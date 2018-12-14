/* Before */

PROCEDURE process_employee (department_id_in IN NUMBER)
IS
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary, last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   FOR rec IN emps_in_dept_cur
   LOOP
      IF rec.salary > 10000000
      THEN
         adjust_comp_for_ceo (rec.salary);
      ELSIF rec.salary BETWEEN 500000 AND 1000000
      THEN
         adjust_comp_for_exec (rec.salary);
      ELSE
         adjust_compensation (rec.employee_id, rec.salary, 10000000);
      END IF;

      update_salary (rec.lname, rec.employee_id, rec.salary);
   END LOOP;
END;

/* After (version 1) */

PROCEDURE process_employee (department_id_in IN NUMBER)
IS
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id
           , salary
           , employees_rp.full_name (last_name, first_name) lname
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   FOR rec IN emps_in_dept_cur
   LOOP
      IF comp_analysis_pkg.ceo_salary_level (rec.salary)
      THEN
         adjust_comp_for_ceo (rec.salary);
      ELSIF comp_analysis_pkg.exec_salary_level (rec.salary)
      THEN
         adjust_comp_for_exec (rec.salary);
      ELSE
         adjust_compensation (rec.employee_id
                                              , rec.salary
                                              , 10000000);
      END IF;

      update_salary (rec.lname, rec.employee_id, rec.salary);
   END LOOP;
END;

/* After (version 1). Move all programs to same package. */

PROCEDURE process_employee (department_id_in IN NUMBER)
IS
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id
           , salary
           , employees_rp.full_name (first_name, last_name) lname
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   FOR rec IN emps_in_dept_cur
   LOOP
      IF comp_analysis_pkg.ceo_salary_level (rec.salary)
      THEN
         comp_analysis_pkg.adjust_comp_for_ceo (rec.salary);
      ELSIF comp_analysis_pkg.exec_salary_level (rec.salary)
      THEN
         comp_analysis_pkg.adjust_comp_for_exec (rec.salary);
      ELSE
         comp_analysis_pkg.adjust_compensation (rec.employee_id
                                              , rec.salary
                                              , 10000000);
      END IF;

      update_salary (rec.lname, rec.employee_id, rec.salary);
   END LOOP;
END;