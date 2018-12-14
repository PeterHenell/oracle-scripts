CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Ellison', 200);

   INSERT INTO plch_employees
        VALUES (200, 'Gates', 400);

   INSERT INTO plch_employees
        VALUES (300, 'Zuckerberg', 600);

   COMMIT;
END;
/

/* PL/SQL does not support a repeat until. 
   Emulate with simple loop and exit when.
*/

DECLARE
   TYPE employees_t IS TABLE OF plch_employees%ROWTYPE
                          INDEX BY PLS_INTEGER;

   l_employees   employees_t;
   l_index       PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.put_line ('EXIT WHEN');

     SELECT *
       BULK COLLECT INTO l_employees
       FROM plch_employees
   ORDER BY employee_id;

   LOOP
      l_index := NVL (l_index + 1, l_employees.FIRST);
      DBMS_OUTPUT.put_line (l_employees (l_index).last_name);
      EXIT WHEN l_employees (l_index).salary > 200;
   END LOOP;
END;
/

DECLARE
   TYPE employees_t IS TABLE OF plch_employees%ROWTYPE
                          INDEX BY PLS_INTEGER;

   l_employees   employees_t;
   l_index       PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.put_line ('REPEAT UNTIL');

     SELECT *
       BULK COLLECT INTO l_employees
       FROM plch_employees
   ORDER BY employee_id;

   REPEAT UNTIL (l_employees (l_index).salary > 200)
   LOOP
      l_index := NVL (l_index + 1, l_employees.FIRST);
      DBMS_OUTPUT.put_line (l_employees (l_index).last_name);
   END LOOP;
END;
/

/* Index not set for initial WHILE loop execution. */

DECLARE
   TYPE employees_t IS TABLE OF plch_employees%ROWTYPE
                          INDEX BY PLS_INTEGER;

   l_employees   employees_t;
   l_index       PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.put_line ('WHILE NOT INITIALIZED');

     SELECT *
       BULK COLLECT INTO l_employees
       FROM plch_employees
   ORDER BY employee_id;

   WHILE (l_employees (l_index).salary <= 200)
   LOOP
      l_index := NVL (l_index + 1, l_employees.FIRST);
      DBMS_OUTPUT.put_line (l_employees (l_index).last_name);
   END LOOP;
END;
/


/* Almost but not quite - need <= in while loop header */

DECLARE
   TYPE employees_t IS TABLE OF plch_employees%ROWTYPE
                          INDEX BY PLS_INTEGER;

   l_employees   employees_t;
   l_index       PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.put_line ('WHILE INITIALIZED');

     SELECT *
       BULK COLLECT INTO l_employees
       FROM plch_employees
   ORDER BY employee_id;

   l_index := l_employees.FIRST;

   WHILE (l_employees (l_index).salary <= 200)
   LOOP
      DBMS_OUTPUT.put_line (l_employees (l_index).last_name);
      l_index := l_index + 1;
   END LOOP;
END;
/

DROP TABLE plch_employees
/