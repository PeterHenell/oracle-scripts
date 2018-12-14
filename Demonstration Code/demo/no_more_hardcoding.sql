PROCEDURE process_employee (department_id_in IN employees.department_id%TYPE)
IS
   /* If not fetching into a record, you would change declarations to:

   l_id       employees.employee_id_id%TYPE;
   l_salary   employees.salary%TYPE;
   l_name     employees_rp.fullname_t;

   */

   CURSOR emps_in_dept_cur (
      dept_id_in IN employees.department_id%TYPE)
   IS
      SELECT employee_id
           , salary
           , employees_rp.fullname (first_name, last_name) full_name
        FROM employees
       WHERE department_id = dept_id_in;

   emp_rec   emps_in_dept_cur%ROWTYPE;
BEGIN
   /* Even better: change to cursor FOR loop! */

   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur INTO emp_rec;

      IF emp_rec.salary > app_config_pkg.c_min_ceo_salary
      THEN
         must_be_ceo;
      END IF;

      analyze_compensation (emp_rec.employee_id
                          , emp_rec.salary
                          , app_config_pkg.c_min_ceo_salary);

      EXIT WHEN emps_in_dept_cur%NOTFOUND;
   END LOOP;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      q$error_manager.
       raise_unanticipated (name1_in    => 'DEPARTMENT_ID'
                          , value1_in   => department_id_in);
END;
/