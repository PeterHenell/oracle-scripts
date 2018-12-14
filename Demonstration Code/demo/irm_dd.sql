CONNECT SCOTT/TIGER

CREATE OR REPLACE PROCEDURE count_all_objects_ir
   AUTHID CURRENT_USER
IS
   dummy INTEGER;
BEGIN
   SELECT COUNT (*) INTO dummy
     FROM ALL_OBJECTS;
     
   DBMS_OUTPUT.PUT_LINE (dummy);
END;
/
GRANT EXECUTE ON count_all_objects_ir TO PUBLIC;
   
CREATE OR REPLACE PROCEDURE count_all_objects_dr
IS
   dummy INTEGER;
BEGIN
   SELECT COUNT (*) INTO dummy
     FROM ALL_OBJECTS;
     
   DBMS_OUTPUT.PUT_LINE (dummy);
END;
/

GRANT EXECUTE ON count_all_objects_ir TO PUBLIC;

CONNECT DEMO/DEMO
@ssoo
exec scott.count_all_objects_ir
exec scott.count_all_objects_dr
   