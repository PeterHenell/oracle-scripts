CREATE OR REPLACE PROCEDURE process_employees (
   department_id_in   IN   employees.department_id%TYPE
)
IS
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_employees   employees_aat;
BEGIN
   SELECT *
   BULK COLLECT INTO l_employees
     FROM employees
    WHERE department_id = department_id_in;

   /*
   Process the data, making any necessary changes.
   */

   /* Delete the current rows. */
   DELETE FROM employees
         WHERE department_id = department_id_in;

   /* Now push the updated data into the table. */
   FORALL indx IN 1 .. l_employees.COUNT SAVE EXCEPTIONS
      INSERT INTO employees
           VALUES l_employees (indx);
EXCEPTION
   WHEN OTHERS
   THEN
      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.put_line
              (   'Error '
               || indx
               || ' occurred on index '
               || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
               || ' attempting to update name to "'
               || enames_with_errors (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)
               || '"'
              );
         DBMS_OUTPUT.put_line
                             (   'Oracle error is '
                              || SQLERRM
                                      (  -1
                                       * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
                                      )
                             );
      END LOOP;
END;