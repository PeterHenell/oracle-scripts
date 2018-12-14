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

   INSERT INTO plch_departments
        VALUES (300, 'Testing');

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

/* Run this in session 1 */

DECLARE
   CURSOR dept_emp_names_cur
   IS
          SELECT emp.last_name, dept.department_name
            FROM plch_employees emp, plch_departments dept
           WHERE emp.department_id = dept.department_id
                 AND dept.department_name = 'Catering'
      FOR UPDATE OF emp.last_name, emp.salary;
BEGIN
   OPEN dept_emp_names_cur;
END;
/

/* Then leaving that session up and running, connect to a new session
   (we will assume HR here) and then try running each of these blocks
*/

CONNECT HR/HR

SET SERVEROUTPUT ON

BEGIN
   UPDATE plch_employees emp
      SET emp.last_name = UPPER (emp.last_name);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

ROLLBACK;

BEGIN
   UPDATE plch_departments dept
      SET dept.department_name = UPPER (dept.department_name);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

ROLLBACK;

BEGIN
   UPDATE plch_employees emp
      SET emp.last_name = UPPER (emp.last_name)
    WHERE department_id <> 200;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

ROLLBACK;

BEGIN
   UPDATE plch_employees emp
      SET emp.department_id = 200;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

ROLLBACK;