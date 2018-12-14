/* Which function will "move" a date one day into the future, minus 30 minutes? */

CREATE OR REPLACE PROCEDURE plch_show_time (date_in IN DATE)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (date_in, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

CREATE OR REPLACE FUNCTION plch_back_to_the_future (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN (date_in + 1) - .5 / 24;
END;
/

BEGIN
   plch_show_time (SYSDATE);
   plch_show_time (plch_back_to_the_future (SYSDATE));
END;
/

CREATE OR REPLACE FUNCTION plch_back_to_the_future (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN (date_in + 1) - 30;
END;
/

BEGIN
   plch_show_time (SYSDATE);
   plch_show_time (plch_back_to_the_future (SYSDATE));
END;
/

CREATE OR REPLACE FUNCTION plch_back_to_the_future (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN NEXT_DAY (date_in, 1) - 30;
END;
/

BEGIN
   plch_show_time (SYSDATE);
   plch_show_time (plch_back_to_the_future (SYSDATE));
END;
/

CREATE OR REPLACE FUNCTION plch_back_to_the_future (date_in IN DATE)
   RETURN DATE
IS
BEGIN
   RETURN (date_in + 1) - 30 / (60 * 24 );
END;
/

BEGIN
   plch_show_time (SYSDATE);
   plch_show_time (plch_back_to_the_future (SYSDATE));
END;
/
