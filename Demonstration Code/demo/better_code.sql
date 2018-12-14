PROCEDURE process_employees (department_id_in IN employees.department_id%TYPE)
IS
   l_name        employees_rp.fullname_t;
   l_employees   employees_tp.employees_tc;
BEGIN
   l_employees := employees_qp.ar_emp_dept_fk (department_id_in);

   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      l_name :=
         employees_rp.fullname (l_employees (indx).first_name
                              , l_employees (indx).last_name
                               );

      IF l_employees (indx).salary > employees_rp.c_min_ceo_salary
            THEN
         must_be_ceo;
      END IF;

      analyze_compensation (l_employees (indx).employee_id
                          , l_employees (indx).salary
                           );
   END LOOP;

   my_commit.perform_commit ();
EXCEPTION
   WHEN OTHERS
   THEN
      q$error_manager.raise_unanticipated
                       (text_in        => 'Unable to process employee successfully'
                      , name1_in       => 'DEPARTMENT_ID'
                      , value1_in      => department_id_in
                       );
END process_employees;