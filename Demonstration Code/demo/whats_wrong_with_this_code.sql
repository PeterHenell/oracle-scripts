/*
What are the problems with this code?

* total will never be non-null

*/

DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 , last_name     VARCHAR2 (100)
 , salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Jobs', 1000000);

   INSERT INTO plch_employees
        VALUES (200, 'Ellison', 1000000);

   INSERT INTO plch_employees
        VALUES (300, 'Gates', 1000000);

   COMMIT;
END;
/

/* I wrote this block so that I could double the salary of all the 
   employees in the company and then print the total salary of all
   the employees.
*/

DECLARE
   l_limit       PLS_INTEGER := 1;
   l_string      VARCHAR2 (100) := SUBSTR ('Steven Feuerstein', 50, 4);
   l_total       NUMBER := 0;

   CURSOR employees_cur
   IS
        SELECT *
          FROM plch_employees
      ORDER BY employee_id;

   TYPE employees_t IS TABLE OF employees_cur%ROWTYPE;

   l_employees   employees_t := employees_t();
BEGIN
   /* INSERT_CODE_HERE */
   l_total := LENGTH (l_string);
   l_limit := 2;
   l_employees.EXTEND (3);
   OPEN employees_cur;
   /* END_INSERT */

   LOOP
      FETCH employees_cur
      BULK COLLECT INTO l_employees
      LIMIT l_limit;

      EXIT WHEN employees_cur%NOTFOUND;

      FOR indx IN 1 .. l_employees.COUNT
      LOOP
         UPDATE plch_employees
            SET salary = salary * 2
          WHERE employee_id = l_employees (indx).employee_id;
      END LOOP;
   END LOOP;

   CLOSE employees_cur;

   l_employees(3).last_name := 'Feuerstein';
   
   FOR rec IN (SELECT * FROM plch_employees)
   LOOP
      l_total := l_total + rec.salary;
   END LOOP;

   DBMS_OUTPUT.put_line ('Total salary=' || l_total);
END;
/

ROLLBACK
/