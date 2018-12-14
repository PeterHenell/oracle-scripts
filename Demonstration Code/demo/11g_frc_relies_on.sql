DROP TABLE plch_employees
/

DROP TABLE plch_employees2
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Feuerstein', 10000);

   INSERT INTO plch_employees
        VALUES (200, 'Ellison', 1000000);

   COMMIT;
END;
/

CREATE TABLE plch_employees2
AS
   SELECT * FROM plch_employees
/

CREATE OR REPLACE PACKAGE plch_frc
IS
   TYPE last_names_aat IS TABLE OF VARCHAR2 (100)
                             INDEX BY PLS_INTEGER;

   FUNCTION last_name (employee_id_in IN INTEGER)
      RETURN VARCHAR2
      RESULT_CACHE;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION last_name (employee_id_in IN INTEGER)
      RETURN VARCHAR2
      RESULT_CACHE RELIES_ON (plch_employees)
   IS
      l_name   VARCHAR2 (100);
   BEGIN
      SELECT last_name
        INTO l_name
        FROM plch_employees
       WHERE employee_id = employee_id_in;

      RETURN l_name;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_frc.last_name (100));
END;
/

DROP TABLE plch_employees
/

CREATE OR REPLACE PACKAGE BODY plch_frc
IS
   FUNCTION last_name (employee_id_in IN INTEGER)
      RETURN VARCHAR2
      RESULT_CACHE RELIES_ON (plch_employees)
   IS
      l_name   VARCHAR2 (100);
   BEGIN
      SELECT last_name
        INTO l_name
        FROM plch_employees2
       WHERE employee_id = employee_id_in;

      RETURN l_name;adfasdf;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_frc.last_name (100));
END;
/