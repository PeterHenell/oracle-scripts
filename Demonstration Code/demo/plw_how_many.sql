ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE FUNCTION plch_how_many (
   strings_in IN OUT DBMS_SQL.varchar2_table)
   RETURN VARCHAR2
IS
   n         NUMBER;
   boolean   DATE;
BEGIN
   CASE strings_in.COUNT
      WHEN 1
      THEN
         RETURN 'abc';
      WHEN 2
      THEN
         RETURN 'def';
      ELSE
         n := 1 / 0;
   END CASE;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN '123';
END;
/

SELECT COUNT (*)
  FROM user_errors ue
 WHERE ue.name = 'PLCH_HOW_MANY'
/