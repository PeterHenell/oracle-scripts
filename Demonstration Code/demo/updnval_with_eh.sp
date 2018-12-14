CREATE OR REPLACE PROCEDURE updnumval (
-- Version with error handling
   col_in     IN   VARCHAR2
  ,start_in   IN   DATE
  ,end_in     IN   DATE
  ,val_in     IN   NUMBER
)
IS
   dml_str   VARCHAR2 (32767);
BEGIN
   dml_str :=
         'UPDATE emp SET '
      || col_in
      || ' = :val 
        WHERE hiredate BETWEEN :lodate AND :hidate 
        AND :val IS NOT NULL';

   EXECUTE IMMEDIATE dml_str
               USING val_in, start_in, end_in, val_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
EXCEPTION
   WHEN OTHERS
   THEN
      p.l ('UPDNVAL ERROR: ' || DBMS_UTILITY.format_error_stack);
      p.l (dml_str);
      p.l (DBMS_UTILITY.format_call_stack);
      RAISE;
END;
/
