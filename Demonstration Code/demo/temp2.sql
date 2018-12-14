CREATE TABLE plch_employees
(
   employee_id   INTEGER PRIMARY KEY,
   last_name     VARCHAR2 (100),
   salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Gerber', 1000000);

   INSERT INTO plch_employees
        VALUES (200, 'Henckels', 2000000);

   INSERT INTO plch_employees
        VALUES (300, 'Kanetsune', 3000000);

   COMMIT;
END;
/

/* Separate collections for each column */

CREATE OR REPLACE TYPE plch_ids_t IS TABLE OF INTEGER
/

CREATE OR REPLACE TYPE plch_names_t IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE FUNCTION plch_ids (filter_in IN VARCHAR2)
   RETURN plch_ids_t
IS
   l_return   plch_ids_t;
BEGIN
     SELECT employee_id
       BULK COLLECT INTO l_return
       FROM plch_employees
      WHERE last_name LIKE filter_in
   ORDER BY last_name;

   RETURN l_return;
END;
/

CREATE OR REPLACE FUNCTION plch_names (filter_in IN INTEGER)
   RETURN plch_names_t
IS
   l_return   plch_names_t;
BEGIN
     SELECT last_name
       BULK COLLECT INTO l_return
       FROM plch_employees
      WHERE employee_id > filter_in
   ORDER BY last_name;

   RETURN l_return;
END;
/

BEGIN
   FOR rec
      IN (SELECT    (SELECT COLUMN_VALUE
                       FROM TABLE (plch_ids (n.COLUMN_VALUE)))
                 || '-'
                 || e.last_name
                    emp_data
            FROM TABLE (plch_names (100)) n, plch_employees e
           WHERE n.COLUMN_VALUE = e.last_name)
   LOOP
      DBMS_OUTPUT.put_line (rec.emp_data);
   END LOOP;
END;
/

/* Table of object types */

CREATE OR REPLACE TYPE plch_employees_ot IS OBJECT
(
   employee_id INTEGER,
   last_name VARCHAR2 (100),
   salary NUMBER
)
/

CREATE OR REPLACE TYPE plch_employees_nt
   IS TABLE OF plch_employees_ot
/

CREATE OR REPLACE FUNCTION plch_emps (filter_in IN VARCHAR2)
   RETURN plch_employees_nt
IS
   l_return   plch_employees_nt;
BEGIN
     SELECT plch_employees_ot (employee_id, last_name, salary)
       BULK COLLECT INTO l_return
       FROM plch_employees
      WHERE last_name LIKE filter_in
   ORDER BY last_name;

   RETURN l_return;
END;
/

BEGIN
   FOR rec
      IN (SELECT employee_id FROM TABLE (plch_emps ('%s%')))
   LOOP
      DBMS_OUTPUT.put_line (
         rec.employee_id || '-' || rec.last_name);
   END LOOP;
END;
/

/* Clean up */

DROP TABLE plch_employees
/

DROP TYPE plch_ids_t
/

DROP TYPE plch_names_t
/

DROP TYPE plch_employees_nt
/

DROP TYPE plch_employees_ot
/

DROP FUNCTION plch_ids
/

DROP FUNCTION plch_names
/

DROP FUNCTION plch_emps
/