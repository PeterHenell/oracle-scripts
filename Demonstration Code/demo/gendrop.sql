SET PAGESIZE 0
SET FEEDBACK OFF
SELECT 'DROP TABLE ' || table_name || ';'
  FROM user_tables
 WHERE table_name LIKE UPPER ('&&firstparm%')

SPOOL drop.cmd
/
SPOOL OFF
@drop.cmd
