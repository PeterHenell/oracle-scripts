DECLARE
   l_start TIMESTAMP;
   l_end TIMESTAMP;

   TYPE strings_aat IS TABLE OF VARCHAR2 ( 32767 )
      INDEX BY PLS_INTEGER;

   my_tab strings_aat;
   --
   l_gap PLS_INTEGER := 1000;
BEGIN
   DBMS_SESSION.free_unused_user_memory;
   --
   my_session.MEMORY;
   l_start := SYSTIMESTAMP;
   sf_timer.start_timer;

   FOR i IN 1 .. 1000000
   LOOP
      my_tab ( i ) := TO_CHAR ( i );
      my_tab ( i + 1 * l_gap ) := TO_CHAR ( i );
      my_tab ( i + 2 * l_gap ) := TO_CHAR ( i );
      my_tab ( i + 3 * l_gap ) := TO_CHAR ( i );
      my_tab ( i + 4 * l_gap ) := TO_CHAR ( i );
      my_tab ( i + 5 * l_gap ) := TO_CHAR ( i );
   END LOOP;

   l_end := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line ( l_end - l_start );
   sf_timer.show_elapsed_time;
   my_session.MEMORY;
END;
/
