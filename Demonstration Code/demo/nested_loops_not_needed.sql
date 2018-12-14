DROP TABLE plch_employees
/

DROP TABLE plch_departments
/

CREATE TABLE plch_departments
(
   department_id     INTEGER PRIMARY KEY
 , department_name   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO plch_departments
        VALUES (100, 'Marketing');

   INSERT INTO plch_departments
        VALUES (200, 'Catering');

   COMMIT;
END;
/

CREATE TABLE plch_employees
(
   employee_id     INTEGER
 , last_name       VARCHAR2 (100)
 , salary          NUMBER
 , department_id   INTEGER    REFERENCES plch_departments (department_id)
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100
              , 'Jobs'
              , 1000000
              , 100);

   INSERT INTO plch_employees
        VALUES (200
              , 'Ellison'
              , 1000000
              , 200);

   INSERT INTO plch_employees
        VALUES (300
              , 'Gates'
              , 1000000
              , 200);

   COMMIT;
END;
/

BEGIN
   FOR drec IN (  SELECT *
                    FROM plch_departments
                ORDER BY department_id)
   LOOP
      sys.DBMS_OUTPUT.put_line (drec.department_name);

      FOR erec IN (  SELECT *
                       FROM plch_employees
                      WHERE department_id = drec.department_id
                   ORDER BY last_name)
      LOOP
         sys.DBMS_OUTPUT.put_line (erec.last_name);
      END LOOP;
   END LOOP;
END;
/

DECLARE
   l_last_id   INTEGER := 0;
BEGIN
   FOR drec IN (  SELECT d.department_id, d.department_name, e.last_name
                    FROM plch_departments d, plch_employees e
                   WHERE d.department_id = e.department_id
                ORDER BY department_id, last_name)
   LOOP
      IF l_last_id <> drec.department_id
      THEN
         sys.DBMS_OUTPUT.put_line (drec.department_name);
         l_last_id := drec.department_id;
      END IF;

      sys.DBMS_OUTPUT.put_line (drec.last_name);
   END LOOP;
END;
/

BEGIN
   FOR drec IN (  SELECT d.department_id, d.department_name, e.last_name
                    FROM plch_departments d, plch_employees e
                   WHERE d.department_id = e.department_id
                ORDER BY department_id, last_name)
   LOOP
      sys.DBMS_OUTPUT.put_line (drec.department_name);
      sys.DBMS_OUTPUT.put_line (drec.last_name);
   END LOOP;
END;
/

/* Now with updates */

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE
 , last_name_like_in    IN VARCHAR2)
IS
BEGIN
   FOR drec IN (SELECT *
                  FROM plch_departments
                 WHERE department_name = department_name_in)
   LOOP
      sys.DBMS_OUTPUT.put_line (drec.department_name);

      FOR erec IN (  SELECT *
                       FROM plch_employees
                      WHERE department_id = drec.department_id
                   ORDER BY last_name)
      LOOP
         IF erec.last_name LIKE last_name_like_in
         THEN
            UPDATE plch_employees
               SET salary = salary * 2
             WHERE employee_id = erec.employee_id;
         END IF;
      END LOOP;
   END LOOP;
END;
/

DECLARE
   l_salary   NUMBER;
BEGIN
   plch_lucky_employees ('Marketing', 'J%');

   SELECT salary
     INTO l_salary
     FROM plch_employees
    WHERE employee_id = 100;

   sys.DBMS_OUTPUT.put_line (l_salary);
END;
/

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE
 , last_name_like_in    IN VARCHAR2)
IS
BEGIN
   UPDATE plch_employees
      SET salary = salary * 2
    WHERE last_name LIKE last_name_like_in
          AND department_name = plch_lucky_employees.department_name_in;
END;
/

DECLARE
   l_salary   NUMBER;
BEGIN
   plch_lucky_employees ('Marketing', 'J%');

   SELECT salary
     INTO l_salary
     FROM plch_employees
    WHERE employee_id = 100;

   sys.DBMS_OUTPUT.put_line (l_salary);
END;
/

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE
 , last_name_like_in    IN VARCHAR2)
IS
BEGIN
   UPDATE plch_employees
      SET salary = salary * 2
    WHERE last_name LIKE last_name_like_in
          AND department_id IN
                 (SELECT department_id
                    FROM plch_departments
                   WHERE department_name = plch_lucky_employees.department_name_in);
END;
/

DECLARE
   l_salary   NUMBER;
BEGIN
   plch_lucky_employees ('Marketing', 'J%');

   SELECT salary
     INTO l_salary
     FROM plch_employees
    WHERE employee_id = 100;

   sys.DBMS_OUTPUT.put_line (l_salary);
END;
/

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE
 , last_name_like_in    IN VARCHAR2)
IS
BEGIN
   FOR drec IN (SELECT *
                  FROM plch_departments
                 WHERE department_name = department_name_in)
   LOOP
      sys.DBMS_OUTPUT.put_line (drec.department_name);

      FOR erec
         IN (  SELECT *
                 FROM plch_employees
                WHERE department_id = drec.department_id
                      AND last_name LIKE last_name_like_in
             ORDER BY last_name)
      LOOP
         UPDATE plch_employees
            SET salary = salary * 2
          WHERE employee_id = erec.employee_id;
      END LOOP;
   END LOOP;
END;
/

DECLARE
   l_salary   NUMBER;
BEGIN
   plch_lucky_employees ('Marketing', 'J%');

   SELECT salary
     INTO l_salary
     FROM plch_employees
    WHERE employee_id = 100;

   sys.DBMS_OUTPUT.put_line (l_salary);
END;
/