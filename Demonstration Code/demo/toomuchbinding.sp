CREATE OR REPLACE PROCEDURE updnumval (-- Version with too much binding
                                       col_in     IN VARCHAR2
                                     , start_in   IN DATE
                                     , end_in     IN DATE
                                     , val_in     IN NUMBER)
IS
BEGIN
   EXECUTE IMMEDIATE 'UPDATE emp SET :col = :val WHERE hiredate BETWEEN :lodate AND :hidate'
      USING col_in
          , val_in
          , start_in
          , end_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
END;
/

BEGIN
   updnumval ('salary'
            , SYSDATE
            , SYSDATE + 10
            , 100);
END;
/