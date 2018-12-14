CREATE OR REPLACE PACKAGE plsql_memory_globals
IS
   TYPE strings_aat IS TABLE OF VARCHAR2 (10000)
      INDEX BY PLS_INTEGER;

   g_list_of_strings         strings_aat;
   g_empty_list_of_strings   strings_aat;
END plsql_memory_globals;
/

DECLARE
   l_strings   plsql_memory_globals.strings_aat;

   PROCEDURE run_my_application
   IS
   BEGIN
      FOR i IN 1 .. 10000
      LOOP
         FOR j IN 1 .. 10
         LOOP
            l_strings (i + j * 100000 - 1) := TO_CHAR (i);

            plsql_memory_globals.g_list_of_strings (
               i + j * 100000 - 1) :=
               TO_CHAR (i);
         END LOOP;
      END LOOP;
   END run_my_application;
BEGIN
   plsql_memory.show_memory_usage;
   plsql_memory.start_analysis;
   run_my_application;
   plsql_memory.show_memory_usage;

   /*
   DOAG 2010:
   Explicitly delete if not using again in session!
   */

   plsql_memory_globals.g_list_of_strings.delete;
   plsql_memory.show_memory_usage;
   plsql_memory_globals.g_list_of_strings :=
      plsql_memory_globals.g_empty_list_of_strings;
   plsql_memory.show_memory_usage;

   DBMS_SESSION.free_unused_user_memory;
   plsql_memory.show_memory_usage;
END plsql_memory_demo;
/