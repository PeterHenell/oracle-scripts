/* Hard coding of Oracle error codes */

BEGIN
   DBMS_OUTPUT.
    put_line (TO_DATE ('2010 10 10 44:55:66', 'YYYY MM DD HH:MI:SS'));
EXCEPTION
   WHEN OTHERS
   THEN
      CASE SQLCODE
         WHEN -1849
         THEN
            DBMS_OUTPUT.put_line ('Bad time');
         WHEN -1830
         THEN
            DBMS_OUTPUT.put_line ('Bad format');
      END CASE;
END;
/

/* Multiple user-defined exceptions, same error code. */

DECLARE
   e_bal_too_low      EXCEPTION;
   e_account_closed   EXCEPTION;
BEGIN
   BEGIN
      RAISE e_bal_too_low;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      RAISE e_account_closed;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;
END;
/