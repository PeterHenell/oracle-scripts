REM Useful values: 

SET SERVEROUTPUT ON SIZE &&1
CALL DBMS_JAVA.SET_OUTPUT(&&1);

CREATE OR REPLACE PROCEDURE lotsaText (
   countem IN NUMBER)
AS LANGUAGE JAVA
   NAME 'HelloAll.lotsaText(int)';
/

/* No overflow error */
exec lotsaText (&&2)

/* Overflow error */
BEGIN
   FOR indx IN 1 .. &&2
   LOOP
      DBMS_OUTPUT.PUT_LINE (
         RPAD ('Hello ', 30, 'Hello '));
   END LOOP;
END; 
/
  
