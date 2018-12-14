SPOOL 12c_grant_roles_units.log

CONNECT system/pwd

CREATE USER c##hr IDENTIFIED BY pwd
/

GRANT CREATE SESSION TO c##hr
/

GRANT CREATE PROCEDURE TO c##hr
/

GRANT CREATE TABLE TO c##hr
/

GRANT UNLIMITED TABLESPACE TO c##hr
/

CREATE USER c##scott IDENTIFIED BY pwd
/

GRANT CREATE SESSION TO c##scott
/

GRANT CREATE PROCEDURE TO c##scott
/

GRANT CREATE TABLE TO c##scott
/

GRANT UNLIMITED TABLESPACE TO c##scott
/

CONNECT c##hr/pwd

CREATE TABLE departments
(
   department_id     INTEGER,
   department_name   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO departments
        VALUES (10, 'IT');

   INSERT INTO departments
        VALUES (20, 'HR');

   COMMIT;
END;
/

CREATE TABLE employees
(
   employee_id     INTEGER,
   department_id   INTEGER,
   last_name       VARCHAR2 (100)
)
/

BEGIN
   DELETE FROM employees;

   INSERT INTO employees
        VALUES (100, 10, 'Price');

   INSERT INTO employees
        VALUES (101, 20, 'Sam');

   INSERT INTO employees
        VALUES (102, 20, 'Joseph');

   INSERT INTO employees
        VALUES (103, 20, 'Smith');

   COMMIT;
END;
/

CONNECT c##scott/pwd

CREATE TABLE employees
(
   employee_id     INTEGER,
   department_id   INTEGER,
   last_name       VARCHAR2 (100)
)
/

BEGIN
   DELETE FROM employees;

   INSERT INTO employees
        VALUES (100, 10, 'Price');

   INSERT INTO employees
        VALUES (104, 20, 'Lakshmi');

   INSERT INTO employees
        VALUES (105, 20, 'Silva');

   INSERT INTO employees
        VALUES (106, 20, 'Ling');

   COMMIT;
END;
/

CONNECT c##hr/pwd

CREATE OR REPLACE PROCEDURE remove_emps_in_dept (
   department_id_in IN employees.department_id%TYPE)
   AUTHID CURRENT_USER
IS
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM departments
    WHERE department_id = department_id_in;

   IF l_count > 2
   THEN
      DELETE FROM employees
            WHERE department_id = department_id_in;
   END IF;
END;
/

GRANT EXECUTE ON remove_emps_in_dept TO c##scott
/

/* Now let's use the new feature! 

   Create a role, grant select on the departments to it,
   then grant that role to the procedure.
*/

CONNECT system/pwd

CREATE ROLE c##hr_departments
/

GRANT c##hr_departments TO c##hr
/

CONNECT c##hr/pwd

GRANT SELECT ON departments TO c##hr_departments
/

GRANT c##hr_departments TO procedure remove_emps_in_dept
/

CONNECT c##scott/pwd

SELECT COUNT (*)
  FROM employees
 WHERE department_id = 20
/

/* Should execute without error */

BEGIN
   c##hr.remove_emps_in_dept (20);
END;
/

SELECT COUNT (*)
  FROM employees
 WHERE department_id = 20
/

ROLLBACK
/

CONNECT system/pwd

DROP ROLE c##hr_departments
/

DROP USER c##hr CASCADE
/

DROP USER c##scott CASCADE
/

SPOOL OFF