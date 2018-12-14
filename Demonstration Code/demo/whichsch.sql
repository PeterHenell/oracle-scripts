SET ECHO ON
SET FEEDBACK ON
SET VERIFY ON

SPOOL whichsch.log

CONNECT SYSTEM/MANAGER

GRANT CREATE TABLE TO SCOTT;

CONNECT SCOTT/TIGER

create or replace PROCEDURE runddl (ddl_in in VARCHAR2)
IS
   cur INTEGER;
   fdbk INTEGER;
BEGIN
   cur := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE (cur, ddl_in, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION -- TVP 5/2001
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
      p.l (ddl_in);
      DBMS_SQL.CLOSE_CURSOR (cur);
      RAISE;
END;
/

GRANT EXECUTE ON runddl TO PUBLIC;

CONNECT demo/demo

DROP TABLE demo_table;

DESC demo_table

exec scott.runddl ('CREATE TABLE demo_table (col1 DATE)');

DESC demo_table

CONNECT SCOTT/TIGER

DESC demo_table

CONNECT demo/demo

exec scott.runddl ('CREATE TABLE demo.demo_table (col1 DATE)');

DESC demo_table

CONNECT SYSTEM/MANAGER

GRANT CREATE ANY TABLE TO SCOTT;

CONNECT demo/demo

exec scott.runddl ('CREATE TABLE demo.demo_table (col1 DATE)');

DESC demo_table

CONNECT SYSTEM/MANAGER

REVOKE CREATE ANY TABLE FROM SCOTT;

CONNECT scott/tiger

DROP TABLE demo_table;

SPOOL OFF
