CREATE OR REPLACE PACKAGE backtrace_drawback
IS
   PROCEDURE proc1;

   PROCEDURE proc2;

   PROCEDURE proc3;
END backtrace_drawback;
/

CREATE OR REPLACE PACKAGE BODY backtrace_drawback
IS
   PROCEDURE proc1
   IS
   BEGIN
      RAISE NO_DATA_FOUND;
   END;

   PROCEDURE proc2
   IS
      l_str   varchar2 (30) := 'calling proc1';
   BEGIN
      DBMS_OUTPUT.put_line (l_str);
      proc1;
   END;

   PROCEDURE proc3
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('calling proc2');
      proc2;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Error stack at top level:');
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
   END;
END backtrace_drawback;
/

BEGIN
   DBMS_OUTPUT.put_line ('Proc3 -> Proc2 -> Proc1 backtrace');
   backtrace_drawback.proc3;
END;
/
