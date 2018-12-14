DECLARE
   l_string   VARCHAR2 (32767) := 'a';
BEGIN
  <<rae>>
   l_string := l_string || 'a';

   BEGIN
      raise_application_error (-20000, l_string);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20000
         THEN
            GOTO rae;
         ELSE
            DBMS_OUTPUT.
             put_line (
               'Maximum length for raise_application_error string = '
               || TO_CHAR (LENGTH (l_string) - 1));
         END IF;
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.
       put_line (
         'Maximum length for raise_application_error string = '
         || TO_CHAR (LENGTH (l_string) - 1));
END;
/

DECLARE
   l_string   VARCHAR2 (32767) := RPAD ('Error', 10000, 'Oh no!');
BEGIN
   raise_application_error (-20000, l_string);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (LENGTH (SQLERRM));
      DBMS_OUTPUT.put_line (LENGTH (DBMS_UTILITY.format_error_stack));
END;
/