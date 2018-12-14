DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
 ,  hire_date     DATE
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100
              ,  'Jobs'
              ,  50000
              ,  DATE '2001-11-5');

   INSERT INTO plch_employees
        VALUES (200
              ,  'Ellison'
              ,  1000000
              ,  DATE '1979-6-22');

   INSERT INTO plch_employees
        VALUES (300
              ,  'Gates'
              ,  1000000
              ,  DATE '1976-3-17');

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE plch_config
IS
   FUNCTION min_salary
      RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_config
IS
   FUNCTION min_salary
      RETURN NUMBER
   IS
   BEGIN
      RETURN 100000;
   END;
END;
/

CREATE OR REPLACE PROCEDURE plch_emp_loop (date_in   IN DATE
                                         ,  NAME_IN   IN VARCHAR2)
IS
   CURSOR emps_cur
   IS
        SELECT *
          FROM plch_employees
      ORDER BY salary DESC;

   emp_rec   emps_cur%ROWTYPE;
BEGIN
   OPEN emps_cur;

   FETCH emps_cur INTO emp_rec;

   WHILE (emps_cur%FOUND AND emp_rec.salary >= plch_config.min_salary)
   LOOP
      IF TO_CHAR (emp_rec.hire_date, 'YYYY') <= TO_CHAR (date_in, 'YYYY')
      THEN
         DBMS_OUTPUT.put_line ('Hired Before');
      END IF;

      IF UPPER (emp_rec.last_name) LIKE UPPER (NAME_IN)
      THEN
         DBMS_OUTPUT.put_line ('Match on name');
      END IF;

      IF TO_CHAR (SYSDATE, 'HH24') < 12
      THEN
         /* Only update salary in the morning */
         UPDATE plch_employees e
            SET salary = salary + 1
          WHERE e.employee_id = emp_rec.employee_id;
      END IF;

      FETCH emps_cur INTO emp_rec;
   END LOOP;

   CLOSE emps_cur;
END;
/

/* 

Declare this local variable:

l_name plch_employees.last_name%type := UPPER(name_in);

and replace UPPER...

----------------

Declare this local variable:

l_min_salary NUMBER := UPPER(name_in);

and replace UPPER...

----------------
*/