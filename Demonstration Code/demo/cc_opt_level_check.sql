ALTER SESSION SET plsql_optimize_level = 1
/

CREATE OR REPLACE PROCEDURE compute_intensive
AUTHID DEFINER
IS
BEGIN
   $IF $$plsql_optimize_level < 2
   $THEN
      $ERROR 'compute_intensive must be compiled with maximum optimization!' $END
   $END
   NULL;
END compute_intensive;
/

/* And an alternative without CC */

CREATE OR REPLACE PROCEDURE compute_intensive
IS
   l_level   PLS_INTEGER;
BEGIN
   SELECT plsql_optimize_level
     INTO l_level
     FROM all_plsql_object_settings
    WHERE name = 'COMPUTE_INTENSIVE';

   IF l_level < 2
   THEN
      RAISE PROGRAM_ERROR;
   END IF;

   NULL;
END compute_intensive;
/

BEGIN
   compute_intensive;
END;
/