CONNECT hr/hr

SET serveroutput on format wrapped

CREATE OR REPLACE PACKAGE plsql_memory_globals
IS
   TYPE strings_aat IS TABLE OF VARCHAR2 (10000)
      INDEX BY PLS_INTEGER;

   g_strings   strings_aat;
END plsql_memory_globals;
/

CREATE OR REPLACE PROCEDURE plsql_memory_demo (
   set_local_in    IN   BOOLEAN
 , set_global_in   IN   BOOLEAN
 , fuum_in         IN   BOOLEAN
)
IS
   c_title   CONSTANT VARCHAR2 (32767)
      :=    CASE
               WHEN set_local_in
                  THEN 'SET'
               ELSE 'NO'
            END
         || ' LOCAL - '
         || CASE
               WHEN set_global_in
                  THEN 'SET'
               ELSE 'NO'
            END
         || ' GLOBAL - '
         || CASE
               WHEN fuum_in
                  THEN 'FUUM'
               ELSE 'NO FUUM'
            END;
   l_strings          plsql_memory_globals.strings_aat;

   PROCEDURE show_results
   IS
   BEGIN
      DBMS_OUTPUT.put_line (c_title);
      DBMS_OUTPUT.put_line ('   Local array count = ' || l_strings.COUNT);
      DBMS_OUTPUT.put_line (   '   Packaged array count = '
                            || plsql_memory_globals.g_strings.COUNT
                           );
      DBMS_OUTPUT.put_line ('-');
      plsql_memory.show_memory_usage;
      DBMS_OUTPUT.put_line ('-');
      /*
      Clean up the global collection.
      */
      plsql_memory_globals.g_strings.DELETE;
   END show_results;

   PROCEDURE run_my_application
   IS
   BEGIN
      FOR i IN 1 .. 10000
      LOOP
         FOR j IN 1 .. 10
         LOOP
            IF set_local_in
            THEN
               l_strings (i + j * 100000 - 1) := TO_CHAR (i);
            END IF;

            IF set_global_in
            THEN
               plsql_memory_globals.g_strings (i + j * 100000 - 1) :=
                                                                  TO_CHAR (i);
            END IF;
         END LOOP;
      END LOOP;
   END run_my_application;
BEGIN
   IF fuum_in
   THEN
      DBMS_SESSION.free_unused_user_memory;
   END IF;

   plsql_memory.start_analysis;
   run_my_application;
   show_results;
END plsql_memory_demo;
/

CONNECT hr/hr

SET serveroutput on format wrapped

BEGIN
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => FALSE
                    , fuum_in            => TRUE
                     );
END;
/

CONNECT hr/hr

SET serveroutput on format wrapped

BEGIN
   plsql_memory_demo (set_local_in       => FALSE
                    , set_global_in      => TRUE
                    , fuum_in            => TRUE
                     );
END;
/

CONNECT hr/hr

SET serveroutput on format wrapped

BEGIN
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => TRUE
                    , fuum_in            => TRUE
                     );
END;
/

CONNECT hr/hr

SET serveroutput on format wrapped

BEGIN
   plsql_memory_demo (set_local_in       => FALSE
                    , set_global_in      => TRUE
                    , fuum_in            => TRUE
                     );
END;
/

BEGIN
   DBMS_OUTPUT.put_line
                   ('Memory usage for multiple operations in single session:');
   DBMS_OUTPUT.put_line ('');
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => FALSE
                    , fuum_in            => TRUE
                     );
   plsql_memory_demo (set_local_in       => FALSE
                    , set_global_in      => TRUE
                    , fuum_in            => TRUE
                     );
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => TRUE
                    , fuum_in            => TRUE
                     );
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => FALSE
                    , fuum_in            => FALSE
                     );
   plsql_memory_demo (set_local_in       => FALSE
                    , set_global_in      => TRUE
                    , fuum_in            => FALSE
                     );
   plsql_memory_demo (set_local_in       => TRUE
                    , set_global_in      => TRUE
                    , fuum_in            => FALSE
                     );
END;
/