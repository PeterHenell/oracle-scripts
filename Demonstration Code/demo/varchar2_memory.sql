DECLARE
   TYPE short_strings_aat
   IS
      TABLE OF VARCHAR2 (4000)
         INDEX BY PLS_INTEGER;

   TYPE long_strings_aat
   IS
      TABLE OF VARCHAR2 (32767)
         INDEX BY PLS_INTEGER;

   l_short_strings   short_strings_aat;
   l_long_strings    long_strings_aat;

   PROCEDURE reset_memory (context_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (context_in);
      DBMS_SESSION.free_unused_user_memory;
      plsql_memory.show_memory_usage (pga_only_in => TRUE);
   END;

   PROCEDURE use_long (count_in IN INTEGER
                     , length_in IN INTEGER
                     , use_delete_in IN BOOLEAN
                      )
   IS
      l_empty   long_strings_aat;
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         l_long_strings (indx) := RPAD ('ABC', length_in, 'DEF');
      END LOOP;

      reset_memory ('>LONG ' || count_in || ' Length ' || length_in);

      IF use_delete_in
      THEN
         l_long_strings.delete ();
         reset_memory ('>LONG DELETED');
      ELSE
         l_long_strings := l_empty;
         reset_memory ('>LONG EMPTIED');
      END IF;
   END;

   PROCEDURE use_short (count_in IN INTEGER, length_in IN INTEGER, use_delete_in IN BOOLEAN)
   IS
      l_empty   short_strings_aat;
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         l_short_strings (indx) := RPAD ('ABC', length_in, 'DEF');
      END LOOP;

      reset_memory ('>SHORT ' || count_in || ' Length ' || length_in);

      IF use_delete_in
      THEN
         l_short_strings.delete ();
         reset_memory ('>SHORT DELETED');
      ELSE
         l_short_strings := l_empty;
         reset_memory ('>SHORT EMPTIED');
      END IF;
   END;
BEGIN
   reset_memory ('> Fresh start');
   use_short (10000, 3, use_delete_in => TRUE);
   use_short (10000, 3, use_delete_in => FALSE);
   use_short (10000, 4000, use_delete_in => TRUE);
   use_long (10000, 3, use_delete_in => TRUE);
   use_long (10000, 3, use_delete_in => FALSE);
   use_long (10000, 4000, use_delete_in => TRUE);
END;