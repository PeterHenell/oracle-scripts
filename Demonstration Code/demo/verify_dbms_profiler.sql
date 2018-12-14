CREATE OR REPLACE PROCEDURE verify_dbms_profiler (is_present_out OUT BOOLEAN
                                 , tables_not_present_out OUT VARCHAR2
                                  )
   IS
      l_not_present   qu_config.maxvarchar2;

      PROCEDURE touch (table_in IN VARCHAR2)
      IS
         l_dummy   PLS_INTEGER;
         c_query CONSTANT qu_config.maxvarchar2
               :=    'select COUNT(*) from plsql_profiler_'
                  || table_in
                  || ' where rownum < 1' ;
      BEGIN
         EXECUTE IMMEDIATE c_query USING OUT l_dummy;
      EXCEPTION
         WHEN OTHERS
         THEN
            BEGIN
               DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
               DBMS_OUTPUT.put_line (c_query);
            END;

            l_not_present :=
                  l_not_present
               || CASE WHEN l_not_present IS NULL THEN NULL ELSE ',' END
               || 'PLSQL_PROFILER_'
               || table_in;
      END touch;
   BEGIN
      /* We must be able to "touch" PLSQL_PROFILER_RUNS/UNITS/DATA */
      touch ('RUNS');
      touch ('UNIT');
      touch ('DATA');
      is_present_out := l_not_present IS NULL;
      tables_not_present_out := l_not_present;
   END verify_dbms_profiler;
/
