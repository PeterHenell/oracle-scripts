CREATE TABLE employees_plus AS
SELECT e1.* FROM employees e1, employees, employees
/

DECLARE
   l_last         PLS_INTEGER := 1;
   l_start        PLS_INTEGER;
   l_end          PLS_INTEGER;

   TYPE employee_tt IS TABLE OF employees_plus.employee_id%TYPE;

   employee_ids   employee_tt;

   TYPE salary_tt IS TABLE OF employees_plus.salary%TYPE;

   salaries       salary_tt;
BEGIN
   SELECT employee_id, salary
   BULK COLLECT INTO employee_ids, salaries
     FROM employees_plus;

   LOOP
      BEGIN
         l_last := l_last + 1;
         EXIT WHEN l_last > 10;
         /* Try to update everything in one pass. */
         FORALL indx IN INDICES OF employee_ids SAVE EXCEPTIONS
            UPDATE employees_plus
               SET salary = salaries (indx)
             WHERE employee_id = employee_ids (indx);
         /* NO error raised? We are done! */
         COMMIT;
         EXIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            /* Save all updates that went through. */
            BEGIN
               DBMS_OUTPUT.put_line ('Rowcount = ' || SQL%ROWCOUNT);
               DBMS_OUTPUT.put_line ('Exceptions count = ' || SQL%BULK_EXCEPTIONS.COUNT);
            END;

            COMMIT;

            /* If there is an error recorded for a given employee ID,
               then set that value to its negative, to indicate that I
               want to try again with this one. */
            FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
            LOOP
               employee_ids (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX) :=
                  -1
                  * employee_ids (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX);
            END LOOP;

            /* Now remove all employee IDs that were updated (are not negative).
               By using INDICES OF above, we can then simply try to update what
               is left. */
            FOR indx IN 1 .. employee_ids.COUNT
            LOOP
               IF employee_ids (indx) < 0
               THEN
                  employee_ids (indx) := -1 * employee_ids (indx);
               ELSE
                  employee_ids.DELETE (indx);
               END IF;
            END LOOP;
      END;
   END LOOP;
END;