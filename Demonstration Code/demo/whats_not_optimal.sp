CREATE OR REPLACE PROCEDURE whats_not_optimal (
   level_in IN PLS_INTEGER DEFAULT 2
)
IS
BEGIN
   FOR program_rec IN (SELECT owner
                            , name
                            , TYPE
                            , plsql_optimize_level
                         FROM all_plsql_object_settings
                        WHERE plsql_optimize_level < level_in)
   LOOP
      DBMS_OUTPUT.
       put_line (
            program_rec.TYPE
         || ' '
         || program_rec.owner
         || '.'
         || program_rec.name
         || ' is optimized at level '
         || program_rec.plsql_optimize_level
      );
   END LOOP;
END whats_not_optimal;
/

BEGIN
   whats_not_optimal ();
END;
/

