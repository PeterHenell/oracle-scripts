CREATE OR REPLACE PROCEDURE updnumval (
   tab_in IN VARCHAR2,
   col_in IN VARCHAR2,
   start_in IN DATE,
   end_in IN DATE,
   val_in IN NUMBER)
IS
BEGIN
   EXECUTE IMMEDIATE
      'UPDATE ' || tab_in || 
        ' SET ' || col_in || ' = :val 
        WHERE hiredate BETWEEN :lodate AND :hidate'
      USING val_in, start_in, end_in;
END;
/

