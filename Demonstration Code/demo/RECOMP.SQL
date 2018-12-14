SET PAGESIZE 0
SET LINESIZE 80
COLUMN command_line1 FORMAT A75
COLUMN command_line2 FORMAT A75
SPOOL recomp.cmd
SELECT 'ALTER '|| 
       DECODE (object_type, 'PACKAGE BODY', 'PACKAGE', object_type) || ' '||
       object_name || ' ' ||
       DECODE (object_type,
          'PACKAGE', 'COMPILE SPECIFICATION;',
          'PACKAGE BODY', 'COMPILE BODY;' , 
          'COMPILE;') command_line1,
       'SHOW ERRORS' command_line2
  FROM user_objects
 WHERE object_type IN ('PACKAGE', 'PACKAGE BODY', 'FUNCTION', 'PROCEDURE')
   AND status = 'INVALID'
 ORDER BY
    DECODE (object_type, 
       'PACKAGE', 1, 'PACKAGE BODY', 4, 'FUNCTION', 2, 'PROCEDURE', 3)
/
SPOOL OFF
SPOOL recomp.cmd
START recomp.cmd
SPOOL OFF

