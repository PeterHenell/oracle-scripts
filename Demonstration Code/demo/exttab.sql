DECLARE
   x INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO x
     FROM emp_load_no_file;
EXCEPTION
   WHEN OTHERS
   THEN
      DECLARE
         l_kup_code PLS_INTEGER;
         l_kup_message VARCHAR2 ( 32767 );
      BEGIN
         l_kup_code := exttab.ERROR_CODE;

         IF l_kup_code = -4040
         THEN
            DBMS_OUTPUT.put_line
                            ( 'Error: file not found - actual error message:' );
            DBMS_OUTPUT.put_line ( exttab.error_message );
         ELSE
            RAISE;
         END IF;
      END;
END;
/

-- Or using the programs that pass the error message in (taking no chances of it 
-- changing to something else)....

DECLARE
   x INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO x
     FROM emp_load_no_file;
EXCEPTION
   WHEN OTHERS
   THEN
      DECLARE
         c_errstk VARCHAR2 ( 32767 ) := DBMS_UTILITY.format_error_stack;
         l_kup_code PLS_INTEGER;
         l_kup_message VARCHAR2 ( 32767 );
      BEGIN
         l_kup_code := exttab.ERROR_CODE ( c_errstk );

         IF l_kup_code = -4040
         THEN
            DBMS_OUTPUT.put_line
                            ( 'Error: file not found - actual error message:' );
            DBMS_OUTPUT.put_line ( exttab.error_message ( c_errstk ));
         ELSE
            RAISE;
         END IF;
      END;
END;
/
