CREATE OR REPLACE PROCEDURE handle_locally (value_in IN NUMBER)
IS
   l_outer   NUMBER := 1;
BEGIN
   DECLARE
      l_inner   NUMBER := 2;
   BEGIN
      IF value_in = 1
      THEN
         RAISE NO_DATA_FOUND;
      ELSE
         RAISE VALUE_ERROR;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20000, 'Inner value = ' || l_inner);
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000
                             , 'Outer value = ' || l_outer
                             , TRUE);
END;
/

BEGIN
   handle_locally (1);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   handle_locally (2);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/