BEGIN
   raise_application_error (-20000, 'Balance too low!');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   raise_application_error (-20999, 'Balance too low!');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

/* This is really confusing: I used a number outside of the range,
   but the number happens to be the error code used by Oracle to
   report this problem! */
   
BEGIN
   raise_application_error (-21000, 'Balance too low!');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   raise_application_error (-1403, 'Balance too low!');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/