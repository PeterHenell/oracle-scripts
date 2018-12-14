connect hr/hr

SET SERVEROUTPUT ON

DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id     INTEGER
 , last_name       VARCHAR2 (100)
 , first_name      VARCHAR2 (100)
 , date_of_birth   DATE
 , salary          NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100
              , 'Feuerstein'
              , 'Steven'
              , '23-sep-1958'
              , 100000);

   INSERT INTO plch_employees
        VALUES (200
              , 'Ellison'
              , 'Larry'
              , '10-may-1954'
              , 10000000000000000);

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION plch_dob (
   employee_id_in IN plch_employees.employee_id%TYPE)
   RETURN VARCHAR2
   RESULT_CACHE
IS
   l_return   DATE;
BEGIN
   SELECT date_of_birth
     INTO l_return
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN TO_CHAR (l_return);
END;
/

GRANT EXECUTE ON plch_dob TO scott
/

ALTER SESSION SET nls_date_format='YYYY-MM-DD'
/

BEGIN
   DBMS_OUTPUT.put_line (plch_dob (100));
END;
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

ALTER SESSION SET nls_date_format='YYYY-MON-DD'
/

BEGIN
   DBMS_OUTPUT.put_line (hr.plch_dob (100));
END;
/

