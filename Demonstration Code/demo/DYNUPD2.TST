set verify off
set feedback off
DECLARE
   timing PLS_INTEGER;
   sals DBMS_SQL.NUMBER_TABLE;
   enames DBMS_SQL.VARCHAR2_TABLE;
BEGIN
   /* Load up the PL/SQL tables. */
   sals(1) := 1111;
   sals(2) := 2222;
   --sals(3) := 3333;
   --sals(4) := 4444;

   enames(1) := '%S%';
   enames(2) := '%I%';

   updemps (enames, sals);
END;
/
SELECT ename, sal FROM emp;
ROLLBACK;

