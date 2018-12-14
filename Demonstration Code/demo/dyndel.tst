set verify off
set feedback off

select ename from emp;

DECLARE
   enames8 DBMS_SQL.VARCHAR2_TABLE;
BEGIN
   /* Load up the PL/SQL table. */
   enames8(100) := '%S%';
   enames8(250) := '%I%';

   delemps (enames8);
END;
/

select ename from emp;

ROLLBACK;

