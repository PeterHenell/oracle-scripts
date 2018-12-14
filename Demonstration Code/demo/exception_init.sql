/* Specify Oracle error codes as negative integers. */

DECLARE
   e_bad_date_format   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_bad_date_format, -1830);
BEGIN
   DBMS_OUTPUT.put_line (TO_DATE ('2010 10 10 44:55:66', 'YYYSS'));
EXCEPTION
   WHEN e_bad_date_format
   THEN
      DBMS_OUTPUT.put_line ('Bad date format');
END;
/

DECLARE
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, 1830);
BEGIN
   RAISE my_exception;
END;
/

/* Strange: you cannot PEI to -1403, must use 100 instead */

DECLARE
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1403);
BEGIN
   RAISE my_exception;
END;
/

DECLARE
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, 100);
BEGIN
   RAISE my_exception;
END;
/

/* Distinguish bewteen user-defined exceptions 

   Note that error message is now null. You must
   use RAISE_APPLICATION_ERROR to associate an
   application specific message to an error code.
*/

DECLARE
   e_bal_too_low      EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_bal_too_low, -20100);

   e_account_closed   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_account_closed, -20200);
BEGIN
   BEGIN
      RAISE e_bal_too_low;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      RAISE e_account_closed;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;
END;
/