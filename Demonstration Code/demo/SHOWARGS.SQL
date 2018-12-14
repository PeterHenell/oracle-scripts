SELECT DISTINCT procedure$
FROM sys.argument$,
dba_objects
WHERE obj# = object_id
AND object_name = UPPER ('&&firstparm');