CREATE OR REPLACE PROCEDURE show_errors
IS
BEGIN
   --DBMS_OUTPUT.put_line ('-------SQLERRM-------------');
   --DBMS_OUTPUT.put_line (SQLERRM);
   DBMS_OUTPUT.put_line ('-------FORMAT_ERROR_STACK--');
   DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   DBMS_OUTPUT.put_line (' ');
END;
/

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   RAISE NO_DATA_FOUND;
END;
/

CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc2;
END pkg1;

CREATE OR REPLACE PACKAGE BODY pkg1
IS
   PROCEDURE proc2
   IS
   BEGIN
      proc1;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE DUP_VAL_ON_INDEX;
   END;
END pkg1;
/

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      NULL;
   END LOOP;

   pkg1.proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000, 'TOP MOST ERROR MESSAGE', TRUE);
END;
/

BEGIN
   proc3;
EXCEPTION
   WHEN OTHERS
   THEN
      show_errors;
END;
/

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      NULL;
   END LOOP;

   pkg1.proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000, 'TOP MOST ERROR MESSAGE', FALSE);
END;
/

BEGIN
   proc3;
EXCEPTION
   WHEN OTHERS
   THEN
      show_errors;
END;
/