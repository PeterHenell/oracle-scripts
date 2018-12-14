CREATE OR REPLACE PROCEDURE close_cv (cv_in IN SYS_REFCURSOR)
IS
BEGIN
   CLOSE cv_in;
END;
/

DECLARE
   CV   SYS_REFCURSOR;
   rec all_source%rowtype;
BEGIN
   OPEN CV FOR
      SELECT *
        FROM all_source
       WHERE ROWNUM < 10;

   close_cv (cv);
   
   fetch cv into rec;
END;
/