CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   RAISE NO_DATA_FOUND;
END proc1;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   DBMS_OUTPUT.put_line ('calling proc1');
   proc1;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.
       put_line ('Proc 2 error: ' || DBMS_UTILITY.format_error_stack);
      RAISE;
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
      DBMS_OUTPUT.
       put_line ('Proc 3 error: ' || DBMS_UTILITY.format_error_stack);
END;
/

BEGIN
   proc3;
END;
/

/* But you cannot call RAISE; outside of an exception handler, 
   even if the program in which it is defined is called inside
   the exception handler. The code won't even compile....
*/

CREATE OR REPLACE PROCEDURE proc2
IS
   PROCEDURE show_error
   IS
   BEGIN
      DBMS_OUTPUT.
       put_line ('Proc 2 error: ' || DBMS_UTILITY.format_error_stack);
      RAISE;
   END;
BEGIN
   DBMS_OUTPUT.put_line ('calling proc1');
   proc1;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      show_error;
   WHEN OTHERS
   THEN
      show_error;
END;
/
