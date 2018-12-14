SET SERVEROUTPUT ON

CREATE TABLE limits_table (n NUMBER)
/

DECLARE
   n   PLS_INTEGER := 1;
BEGIN
   LOOP
      EXECUTE IMMEDIATE 'create or replace trigger limits_table' 
                      || n || 
                      ' before insert on limits_table for each row begin null; end;';
      DBMS_OUTPUT.put_line ('Created ' || n || ' triggers!');
      n := n + 1;
   END LOOP;
END;
/

SELECT COUNT ( * )
  FROM user_triggers
 WHERE trigger_name LIKE 'LIMITS_TABLE%'
/

BEGIN
   FOR rec IN (SELECT *
                 FROM user_triggers
                WHERE trigger_name LIKE 'LIMITS_TABLE%')
   LOOP
      EXECUTE IMMEDIATE 'drop trigger ' || rec.trigger_name;
   END LOOP;
END;
/