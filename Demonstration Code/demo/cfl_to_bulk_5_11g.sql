/*
Take advantage of 11g ability to reference fields of records in FORALL.
*/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in         IN employees.department_id%TYPE
 ,  newsal_in       IN employees.salary%TYPE
 ,  bulk_limit_in   IN PLS_INTEGER DEFAULT 100)
IS
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   CURSOR employees_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employees
       WHERE department_id = dept_in
      FOR UPDATE;

   TYPE employees_tt IS TABLE OF employees_cur%ROWTYPE
                           INDEX BY PLS_INTEGER;

   l_employees   employees_tt;

   PROCEDURE adj_comp_for_arrays
   IS
      l_index   PLS_INTEGER;

      PROCEDURE adjust_compensation (
         id_in       IN INTEGER
       ,  salary_in   IN NUMBER)
      IS
      BEGIN
         NULL;
      END;
   BEGIN
      /* IFMC Nov 2008 Cannot go 1 to COUNT */
      l_index := l_employees.FIRST;

      WHILE (l_index IS NOT NULL)
      LOOP
         adjust_compensation (
            l_employees (l_index).employee_id
          ,  l_employees (l_index).salary);
         l_index := l_employees.NEXT (l_index);
      END LOOP;
   END adj_comp_for_arrays;

   PROCEDURE insert_history
   IS
   BEGIN
      FORALL indx IN 1 .. l_employees.COUNT SAVE EXCEPTIONS
         INSERT
           INTO employee_history (employee_id
                                ,  salary
                                ,  hire_date)
         VALUES (
                   l_employees (indx).employee_id
                 ,  l_employees (indx).salary
                 ,  l_employees (indx).hire_date);
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Log the error
            log_error (
                  'Unable to insert history row for employee '
               || l_employees (
                     SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX).employee_id
             ,  SQL%BULK_EXCEPTIONS (indx).ERROR_CODE);
            /*
            Communicate this failure to the update phase:
            Delete this row so that the update will not take place.
            */
            l_employees.delete (
               SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX);
         END LOOP;
   END insert_history;

   PROCEDURE update_employees
   IS
   BEGIN
      /*
        Use Oracle10g INDICES OF to avoid errors
        from a sparsely-populated employee_ids collection.
      */
      FORALL indx IN INDICES OF l_employees
        SAVE EXCEPTIONS
         UPDATE employees
            SET salary = l_employees (indx).salary
              ,  hire_date = l_employees (indx).hire_date
          WHERE employee_id =
                   l_employees (indx).employee_id;
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            log_error (
                  'Unable to update salary for employee '
               || l_employees (
                     SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX).employee_id
             ,  SQL%BULK_EXCEPTIONS (indx).ERROR_CODE);
         END LOOP;
   END update_employees;
BEGIN
   OPEN employees_cur;

   LOOP
      FETCH employees_cur
      BULK COLLECT INTO l_employees
      LIMIT bulk_limit_in;

      EXIT WHEN l_employees.COUNT = 0;

      insert_history;
      adj_comp_for_arrays;
      update_employees;
   END LOOP;
END upd_for_dept;
/
