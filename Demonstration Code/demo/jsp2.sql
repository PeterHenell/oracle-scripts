/* Compile, load, create, and call Java stored procedure
   Written by Bill Pribyl, Datacraft
*/

REM Must have Java compiler installed somewhere

host javac ForPLSQL.java

host loadjava -user scott/tiger -oci8 -resolve ForPLSQL.class

CREATE OR REPLACE FUNCTION hello_emp 
   (empno_in IN NUMBER)
RETURN VARCHAR2
AS LANGUAGE JAVA
   NAME 'ForPLSQL.Emp(int) return java.lang.String';
/

PAUSE Function created - now call with DO.PL

EXEC DBMS_OUTPUT.PUT_LINE(hello_emp(7499))

PAUSE Use 8.1 CALL command

VARIABLE thename VARCHAR2(12)
CALL hello_emp(7499) INTO :thename;
PRINT :thename
