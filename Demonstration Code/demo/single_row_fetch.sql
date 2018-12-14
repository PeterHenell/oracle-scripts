CREATE TABLE plch_employees
(
   employee_id   INTEGER PRIMARY KEY
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      INSERT INTO plch_employees
           VALUES (indx, 'Employee' || indx, 1000);
   END LOOP;

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE plch_use_ref_cursor (
   id_in IN plch_employees.employee_id%TYPE)
IS
   l_cv         SYS_REFCURSOR;
   l_employee   plch_employees%ROWTYPE;
BEGIN
   OPEN l_cv FOR 'select * from plch_employees where employee_id = :id'
      USING id_in;

   FETCH l_cv INTO l_employee;

   CLOSE l_cv;
END;
/

CREATE OR REPLACE PROCEDURE plch_use_nds (
   id_in IN plch_employees.employee_id%TYPE)
IS
   l_employee   plch_employees%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE 'select * from plch_employees where employee_id = :id'
      INTO l_employee
      USING id_in;
END;
/

CREATE OR REPLACE PROCEDURE plch_use_implicit (
   id_in IN plch_employees.employee_id%TYPE)
IS
   l_employee   plch_employees%ROWTYPE;
BEGIN
   SELECT *
     INTO l_employee
     FROM plch_employees
    WHERE employee_id = id_in;
END;
/

CREATE OR REPLACE PROCEDURE plch_use_explicit (
   id_in IN plch_employees.employee_id%TYPE)
IS
   CURSOR emp_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE employee_id = id_in;

   l_employee   plch_employees%ROWTYPE;
BEGIN
   OPEN emp_cur;

   FETCH emp_cur INTO l_employee;

   CLOSE emp_cur;
END;
/

CREATE OR REPLACE PROCEDURE plch_use_cfl (
   id_in IN plch_employees.employee_id%TYPE)
IS
   l_employee   plch_employees%ROWTYPE;
BEGIN
   FOR rec IN (SELECT *
                 FROM plch_employees
                WHERE employee_id = id_in)
   LOOP
      l_employee := rec;
   END LOOP;
END;
/

BEGIN
   plch_timer.start_timer;

   FOR indx IN 1 .. 50000
   LOOP
      plch_use_implicit (575);
   END LOOP;

   plch_timer.show_elapsed_time ('Implicit');

   FOR indx IN 1 .. 50000
   LOOP
      plch_use_nds (575);
   END LOOP;

   plch_timer.show_elapsed_time ('NDS');

   FOR indx IN 1 .. 50000
   LOOP
      plch_use_explicit (575);
   END LOOP;

   plch_timer.show_elapsed_time ('Explicit');

   FOR indx IN 1 .. 50000
   LOOP
      plch_use_cfl (575);
   END LOOP;

   plch_timer.show_elapsed_time ('CFL');

   FOR indx IN 1 .. 50000
   LOOP
      plch_use_ref_cursor (575);
   END LOOP;

   plch_timer.show_elapsed_time ('RC');
END;
/

/* clean up */

DROP TABLE plch_employees
/

DROP PROCEDURE plch_use_implicit
/

DROP PROCEDURE plch_use_explicit
/

DROP PROCEDURE plch_use_cfl
/

DROP PROCEDURE plch_use_nds
/

DROP PROCEDURE plch_use_ref_cursor
/

/*
"Implicit" completed in: 1.87 seconds
"NDS" completed in: 1.95 seconds
"Explicit" completed in: 2.19 seconds
"CFL" completed in: 2.12 seconds
"RC" completed in: 3.42 seconds
*/