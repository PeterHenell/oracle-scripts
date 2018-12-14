CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc1;
END pkg1;
/

CREATE OR REPLACE PACKAGE BODY pkg1
IS
   PROCEDURE proc1
   IS
   BEGIN
      NULL;
      DBMS_OUTPUT.put_line ('running proc1');
      RAISE NO_DATA_FOUND;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line
            ('Error stack in block where raised:'
            );
         p.l (DBMS_UTILITY.format_call_stack);
         RAISE;
   END;
END pkg1;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc1');
   pkg1.proc1;
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE VALUE_ERROR;
END;
/

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc2');
   proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line
                ('Error stack at top level:');
      DBMS_OUTPUT.put_line
            (DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   proc3;
END;
/