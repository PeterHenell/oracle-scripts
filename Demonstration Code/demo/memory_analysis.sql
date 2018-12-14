DECLARE
   TYPE strings_aat IS TABLE OF VARCHAR2 ( 32767 )
      INDEX BY PLS_INTEGER;

   my_tab strings_aat;

   PROCEDURE perform_analysis ( count_in IN PLS_INTEGER, gap_in IN PLS_INTEGER )
   IS
   BEGIN
      DBMS_SESSION.free_unused_user_memory;
      --
      my_session.MEMORY ( pga_only => TRUE );

      FOR i IN 1 .. count_in
      LOOP
         my_tab ( i ) := TO_CHAR ( i );
         my_tab ( i + 1 * gap_in ) := TO_CHAR ( i );
         my_tab ( i + 2 * gap_in ) := TO_CHAR ( i );
         my_tab ( i + 3 * gap_in ) := TO_CHAR ( i );
         my_tab ( i + 4 * gap_in ) := TO_CHAR ( i );
         my_tab ( i + 5 * gap_in ) := TO_CHAR ( i );
      END LOOP;

      DBMS_OUTPUT.put_line ( my_tab.COUNT );
      my_session.MEMORY ( pga_only => TRUE );
   END perform_analysis;
BEGIN
   perform_analysis ( 1000, 1000 );
   perform_analysis ( 100000, 100000 );
   perform_analysis ( 100000, 1000000 );
END;
/
