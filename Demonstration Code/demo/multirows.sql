CREATE OR REPLACE PACKAGE multirows
IS
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   FUNCTION emps_in_dept ( dept_in IN employee.department_id%TYPE )
      RETURN employees_aat;
END multirows;
/

CREATE OR REPLACE PACKAGE BODY multirows
IS
   FUNCTION emps_in_dept ( dept_in IN employee.department_id%TYPE )
      RETURN employees_aat
   IS
      l_employees employees_aat;
   BEGIN
      -- Retrieve all rows matching the possible where clause
      -- and deposit directly into the collection.
      SELECT *
      BULK COLLECT INTO l_employees
        FROM employees
       WHERE department_id = dept_in;

      RETURN l_employees;
   END emps_in_dept;
END multirows;
/
