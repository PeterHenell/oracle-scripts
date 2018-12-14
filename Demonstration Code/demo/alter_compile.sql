/*
Find all the invalid program units and recompile them. Notice that this 
script does not pay any regard to the dependencies among program units, so
one recompile might invalidate another.
*/

DECLARE
   CURSOR invalids_cur
   IS
        SELECT object_name, object_type
          FROM user_objects
         WHERE status = 'INVALID'
      ORDER BY object_type;
BEGIN
   FOR rec IN invalids_cur
   LOOP
      IF rec.object_type = 'PACKAGE'
      THEN
         rec.object_type := 'PACKAGE SPECIFICATION';
      END IF;

      DBMS_DDL.alter_compile (rec.object_type
                            , USER
                            , rec.object_name
                            , reuse_settings   => TRUE);
                            
      /* ALL_PLSQL_OBJECT_SETTINGS */                            
   END LOOP;
END;
/