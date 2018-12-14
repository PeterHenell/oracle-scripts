CREATE OR REPLACE PROCEDURE updnumval (
   col_in                     IN       VARCHAR2
 , start_in                   IN       DATE
 , end_in                     IN       DATE
 , val_in                     IN       NUMBER
)
IS
   l_update   varchar2(1000)
      :=    'UPDATE employees SET '
         || col_in
         || ' = :val 
        WHERE hire_date BETWEEN :lodate AND :hidate
          AND :val IS NOT NULL';
BEGIN
   EXECUTE IMMEDIATE l_update
               USING val_in, start_in, end_in, val_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (l_update);
END;
/