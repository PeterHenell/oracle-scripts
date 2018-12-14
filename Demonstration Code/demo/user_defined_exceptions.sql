DECLARE
   e_balance_too_low   EXCEPTION;
BEGIN
   RAISE e_balance_too_low;
EXCEPTION
   WHEN e_balance_too_low
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (SQLERRM);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

CREATE OR REPLACE PACKAGE app_exceptions
IS
   e_balance_too_low     EXCEPTION;
   e_mortgage_too_high   EXCEPTION;
END;
/

BEGIN
   RAISE app_exceptions.e_balance_too_low;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (SQLERRM);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/
