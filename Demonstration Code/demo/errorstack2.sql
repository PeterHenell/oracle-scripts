CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE proc1;

   PROCEDURE proc2;
END plch_pkg;

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE proc1
   IS
   BEGIN
      RAISE NO_DATA_FOUND;
   END;

   PROCEDURE proc2
   IS
   BEGIN
      proc1;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE DUP_VAL_ON_INDEX;
   END;
END plch_pkg;
/

BEGIN
   plch_pkg.proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
END;
/

BEGIN
   plch_pkg.proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   BEGIN
      plch_pkg.proc2;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20000, 'Problem encountered!');
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   plch_pkg.proc1;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   BEGIN
      plch_pkg.proc2;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20000
                                ,  'Problem encountered!'
                                ,  TRUE);
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

/* Clean up */

DROP PACKAGE plch_pkg
/