CREATE TABLE otn_employee (
   employee_id NUMBER PRIMARY KEY,
   department_id NUMBER,
   salary NUMBER)
/

DECLARE
   l_department_id   otn_employee.department_id%TYPE := 10;

   CURSOR allrows_cur
   IS
      SELECT        *
               FROM otn_employee
              WHERE department_id = l_department_id
      FOR UPDATE OF salary;

   -- Declaration of associative array of records based on otn_employee
   TYPE otn_employee_aat IS TABLE OF otn_employee%ROWTYPE
      INDEX BY BINARY_INTEGER;

   l_otn_employee   otn_employee_aat;
   l_row             PLS_INTEGER;
BEGIN
   OPEN allrows_cur;

   LOOP
      FETCH allrows_cur
      BULK COLLECT INTO l_otn_employee LIMIT 100;

      EXIT WHEN l_otn_employee.COUNT = 0;
      l_row := l_otn_employee.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         UPDATE otn_employee
            SET salary = l_otn_employee (l_row).salary + 100
          WHERE CURRENT OF allrows_cur;

         l_row := l_otn_employee.NEXT (l_row);
      END LOOP;
   END LOOP;

   -- Clean up when done: close the cursor and delete everything
   -- in the collection.
   CLOSE allrows_cur;

   l_otn_employee.DELETE;
END;