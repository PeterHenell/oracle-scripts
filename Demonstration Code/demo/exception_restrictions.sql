/*
Cannot pass an exception as an argument
*/

CREATE OR REPLACE PROCEDURE handle_exception (exception_in IN exception)
IS
BEGIN
   NULL;
END;
/

/*
Cannot work with an exception as a variable
*/

DECLARE
   l_exception1   EXCEPTION;

   l_exception2   EXCEPTION;
BEGIN
   /* PLS-00321: expression 'L_EXCEPTION1' is inappropriate as the left hand side of an assignment statement */
   l_exception1 := l_exception2;
END;
/

/*
Can only raise and handle
*/

DECLARE
   l_exception1   EXCEPTION;

   l_exception2   EXCEPTION;
BEGIN
   /* PLS-00321: expression 'L_EXCEPTION1' is inappropriate as the left hand side of an assignment statement */
   RAISE l_exception1;
EXCEPTION
   WHEN l_exception1
   THEN
      DBMS_OUTPUT.put_line ('Something went wrong!');
END;
/