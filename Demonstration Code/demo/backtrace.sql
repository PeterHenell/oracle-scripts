SET FEEDBACK OFF

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   DBMS_OUTPUT.put_line ('running proc1');
   RAISE NO_DATA_FOUND;
END;
/

CREATE OR REPLACE PROCEDURE proc2
IS
   l_str   VARCHAR2 (30) := 'calling proc1';
BEGIN
   DBMS_OUTPUT.put_line (l_str);
   proc1;
END;
/

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc2');
   proc2;
END;
/

REM Before backtrace was available....
REM error goes unhandled to see line number.

BEGIN
   DBMS_OUTPUT.put_line ('Proc3 -> Proc2 -> Proc1 unhandled');
   proc3;
END;
/

REM Trap and display error "stack"

BEGIN
   DBMS_OUTPUT.put_line ('Proc3 -> Proc2 -> Proc1 unhandled');
   proc3;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

REM Now redefined top level program to show the backtrace.

CREATE OR REPLACE PROCEDURE proc3
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
/

BEGIN
   DBMS_OUTPUT.put_line ('Proc3 -> Proc2 -> Proc1 backtrace');
   proc3;
END;
/

REM Put backtrace at the lowest level and then propagate
REM the exception upwards.

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   DBMS_OUTPUT.put_line ('running proc1');
   RAISE NO_DATA_FOUND;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error stack in block where raised:');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
      RAISE;
END;
/

REM Use the backtrace package to extract information
REM from the backtrace stack.

@bt.pkg

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc2');
   proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error stack at top level:');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
      bt.show_info (DBMS_UTILITY.format_error_backtrace);
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Proc3 -> Proc2 -> Proc1, re-reraise in Proc1');
   proc3;
END;
/

REM Multiple raises through the stack. Note that the
REM the string returned by the backtrace function is
REM reset in each case.

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   DBMS_OUTPUT.put_line ('running proc1');
   RAISE NO_DATA_FOUND;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error stack in block where raised:');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
      RAISE;
END;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc1');
   proc1;
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
      DBMS_OUTPUT.put_line ('Error stack at top level:');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
      bt.show_info (DBMS_UTILITY.format_error_backtrace);
END;
/

BEGIN
   DBMS_OUTPUT.put_line
           ('Proc3 -> Proc2 -> Proc1, re-reraise in Proc1, raise VE in Proc2');
   proc3;
END;
/