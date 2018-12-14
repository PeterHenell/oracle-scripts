CREATE OR REPLACE PACKAGE employees_dml
IS
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   PROCEDURE insert_some (employees_in IN employees_aat);
END employees_dml;
/

CREATE OR REPLACE PACKAGE BODY employees_dml
IS
   PROCEDURE insert_some (employees_in IN employees_aat)
   IS
      TYPE index_values_aat IS TABLE OF PLS_INTEGER
         INDEX BY PLS_INTEGER;

      l_values_of                   index_values_aat;
      l_index                       PLS_INTEGER;
   BEGIN
      -- Only insert those employees with a salary >= 10000.
      l_index := employees_in.FIRST;

      WHILE (l_index IS NOT NULL)
      LOOP
         IF employees_in (l_index).salary >= 10000
         THEN
            l_values_of (l_values_of.COUNT + 1) := l_index;
         END IF;

         l_index := employees_in.NEXT (l_index);
      END LOOP;

      FORALL indx IN VALUES OF l_values_of
         INSERT INTO employees
              VALUES employees_in (indx);
   END insert_some;
END employees_dml;
/

SELECT COUNT(*)
  FROM employees
 WHERE salary < 10000
/

DECLARE
   l_employees                   employees_dml.employees_aat;
BEGIN
   SELECT *
   BULK COLLECT INTO l_employees
     FROM employees;

   DELETE FROM employees;

   employees_dml.insert_some (l_employees);
END;
/

SELECT COUNT(*)
  FROM employees
 WHERE salary < 10000
/
ROLLBACK
/