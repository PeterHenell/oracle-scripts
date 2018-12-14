SET ECHO ON
SET FEEDBACK ON
SET VERIFY ON

SPOOL dumb5.log

CONNECT SYSTEM/MANAGER

GRANT CREATE TABLE TO SCOTT;

CONNECT SCOTT/TIGER

create or replace PROCEDURE runddl (ddl_in in VARCHAR2)
IS
   cur INTEGER:= DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
BEGIN
   DBMS_SQL.PARSE (cur, ddl_in, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/

GRANT EXECUTE ON runddl TO PUBLIC;

CONNECT demo/demo

DROP TABLE demo_table;

exec scott.runddl ('CREATE TABLE demo_table (col1 DATE)');

PAUSE

DESC demo_table

PAUSE

CONNECT SCOTT/TIGER

DESC demo_table

CONNECT demo/demo

exec scott.runddl ('DROP TABLE SYS.TAB$');

spool off