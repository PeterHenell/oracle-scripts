/*
Verify that memory is truly released when you delete
from a collection.
*/

DECLARE
   l_local_strings1   plsql_memory_globals.strings_aat;
   l_local_strings2   plsql_memory_globals.strings_aat;

   PROCEDURE show_results (title_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (title_in);
      DBMS_OUTPUT.put_line ('');
      plsql_memory.show_memory_usage;
      DBMS_OUTPUT.put_line ('');
   END show_results;
BEGIN
   DBMS_SESSION.free_unused_user_memory;
   /*
   Fill a local collection and show memory usage.
   */
   plsql_memory.start_analysis;

   FOR i IN 1 .. 10000
   LOOP
      l_local_strings1 (i) := TO_CHAR (i);
   END LOOP;

   show_results ('First local collection');
   /*
   Now delete the contents of that collection and fill the
   second local collection
   */
   l_local_strings1.DELETE;
   plsql_memory.start_analysis;

   FOR i IN 1 .. 10000
   LOOP
      l_local_strings2 (i) := TO_CHAR (i);
   END LOOP;

   show_results ('Second local collection - no additional memory used!');
END plsql_memory_demo;
/