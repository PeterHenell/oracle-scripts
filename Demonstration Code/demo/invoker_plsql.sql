CONNECT hr/hr

CREATE OR REPLACE PROCEDURE show_user (display_in IN BOOLEAN DEFAULT TRUE)
AUTHID CURRENT_USER
IS
   l_user varchar2(30) := user;
BEGIN
   IF display_in
   THEN
      DBMS_OUTPUT.put_line ('> OWNED BY HR, RUN BY ' || l_user);
   END IF;
END show_user;
/

CREATE OR REPLACE PROCEDURE show_user_dynamic (
   display_in IN BOOLEAN DEFAULT TRUE
)
AUTHID CURRENT_USER
IS
BEGIN
   IF display_in
   THEN
      EXECUTE IMMEDIATE 'BEGIN show_user; END;';
   ELSE
      EXECUTE IMMEDIATE 'BEGIN show_user (FALSE); END;';
   END IF;
END show_user_dynamic;
/

GRANT EXECUTE ON show_user_dynamic TO scott
/
GRANT EXECUTE ON show_user TO scott
/
CONNECT scott/tiger
SET serveroutput on

CREATE OR REPLACE PROCEDURE show_user (display_in IN BOOLEAN DEFAULT TRUE)
AUTHID CURRENT_USER
IS
   l_user varchar2(30) := user;
BEGIN
   IF display_in
   THEN
      DBMS_OUTPUT.put_line ('> OWNED BY SCOTT, RUN BY ' || l_user);
   END IF;
END show_user;
/

BEGIN
dbms_output.put_line ('SCOTT.SHOW_USER (static):');
   show_user;
dbms_output.put_line ('HR.SHOW_USER (static):');
   hr.show_user;
dbms_output.put_line ('HR.SHOW_USER (dynamic):');
   hr.show_user_dynamic;
END;
/

/*
And now test performance difference.
*/

BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. 100000
   LOOP
      hr.show_user (FALSE);
   END LOOP;

   sf_timer.show_elapsed_time ('Static Invocation');
   sf_timer.start_timer;

   FOR indx IN 1 .. 100000
   LOOP
      hr.show_user_dynamic (FALSE);
   END LOOP;

   sf_timer.show_elapsed_time ('Dynamic Invocation');
/* 
100000  
Static Invocation Elapsed: .03 seconds.
Dynamic Invocation Elapsed: 2.91 seconds.

1000000
Static Invocation Elapsed: .32 seconds.
Dynamic Invocation Elapsed: 29.23 seconds.
*/
END;
/