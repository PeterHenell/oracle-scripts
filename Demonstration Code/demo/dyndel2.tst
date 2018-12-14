set verify off
set feedback off
DECLARE
   enames8 DBMS_SQL.VARCHAR2_TABLE;
BEGIN
   /* Load up the PL/SQL table. */
   enames8(100) := '%S%';
   enames8(250) := '%I%';
   enames8(251) := '%T%';
   enames8(252) := '%Q%';
   enames8(253) := '%R%';
   enames8(254) := '%V%';
   enames8(255) := '%Y%';
   enames8(256) := '%)%';

   delemps (enames8);
END;
/

