SET PAGESIZE 66
COLUMN object_type FORMAT A20
COLUMN object_name FORMAT A30
COLUMN status FORMAT A10
BREAK ON object_type SKIP 1
SPOOL psobj.lis
SELECT   object_type, object_name, status
    FROM user_objects
   WHERE object_type IN ('PACKAGE',
                        'PACKAGE BODY',
                        'FUNCTION',
                        'PROCEDURE',
                        'TYPE',
                        'TYPE BODY'
                       )
ORDER BY object_type, status, object_name
/

SPOOL OFF
