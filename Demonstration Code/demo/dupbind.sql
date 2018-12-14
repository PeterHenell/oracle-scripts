/* Duplicate placeholders in dynamic SQL */

CREATE OR REPLACE PROCEDURE updnumval (col_in     IN VARCHAR2
                                     , start_in   IN DATE
                                     , end_in     IN DATE
                                     , val_in     IN NUMBER)
IS
   dml_str   VARCHAR2 (32767)
      :=    'UPDATE employees SET '
         || col_in
         || ' = :val 
        WHERE hire_date BETWEEN :lodate AND :hidate 
		  AND :val IS NOT NULL';
BEGIN
   EXECUTE IMMEDIATE dml_str
      USING val_in
          , start_in
          , end_in
          , val_in;
END updnumval;
/


BEGIN
   updnumval ('salary'
            , SYSDATE
            , SYSDATE
            , 100);
   ROLLBACK;
END;
/

/* Duplicate placeholders in dynamic PL/SQL */

CREATE OR REPLACE PROCEDURE updnumval (col_in     IN VARCHAR2
                                     , start_in   IN DATE
                                     , end_in     IN DATE
                                     , val_in     IN NUMBER)
IS
   dml_str   VARCHAR2 (32767)
      :=    'BEGIN
          UPDATE employees SET '
         || col_in
         || ' = :val 
           WHERE hire_date BETWEEN :lodate AND :hidate 
		  AND :val IS NOT NULL;
       END;';
BEGIN
   EXECUTE IMMEDIATE dml_str USING val_in, start_in, end_in;
END updnumval;
/

BEGIN
   updnumval ('salary'
            , SYSDATE
            , SYSDATE
            , 1000);
   ROLLBACK;
END;
/