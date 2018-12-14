BEGIN
   DBMS_OUTPUT.put_line (
      'RAISE_APPLICATION_ERROR with keep stack set to FALSE'
   );

   BEGIN
      raise_application_error (-20000, 'Error 1!');
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, 'Error 2!', FALSE);
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'RAISE_APPLICATION_ERROR with keep stack set to TRUE'
   );

   BEGIN
      raise_application_error (-20000, 'Error 1!');
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, 'Error 2!', TRUE);
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/