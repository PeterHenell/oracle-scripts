CREATE OR REPLACE PROCEDURE check_trim ( count_in IN PLS_INTEGER )
IS
   -- Faster to trim in bulk or individually?
   TYPE numbers_aat IS TABLE OF NUMBER;

   l_numbers numbers_aat := numbers_aat ( );
   l_start PLS_INTEGER;

   PROCEDURE init_test
   IS
   BEGIN
      DBMS_SESSION.free_unused_user_memory;
      l_start := DBMS_UTILITY.get_cpu_time;
   END init_test;

   PROCEDURE show_elapsed ( NAME_IN IN VARCHAR2 )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    '"'
                             || NAME_IN
                             || '" elapsed CPU time: '
                             || TO_CHAR (   (   DBMS_UTILITY.get_cpu_time
                                              - l_start
                                            )
                                          / 100
                                        )
                             || ' seconds'
                           );
   END show_elapsed;
BEGIN
   l_numbers.EXTEND ( 1000000 );
   init_test;

   FOR indx IN 1 .. count_in
   LOOP
      l_numbers.TRIM;
   END LOOP;

   show_elapsed ( 'Individual trims for ' || count_in || ' iterations' );
   --
   init_test;
   l_numbers.TRIM ( count_in );
   show_elapsed ( 'Bulk trims for ' || count_in || ' iterations' );
END;
/

BEGIN
   check_trim ( 1000 );
   check_trim ( 10000 );
   check_trim ( 50000 );
   check_trim ( 100000 );
/*
"Individual trims for 1000 iterations" elapsed CPU time: 0 seconds
"Bulk trims for 1000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 10000 iterations" elapsed CPU time: .28 seconds
"Bulk trims for 10000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 50000 iterations" elapsed CPU time: 6.9 seconds
"Bulk trims for 50000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 100000 iterations" elapsed CPU time: 77.42 seconds
"Bulk trims for 100000 iterations" elapsed CPU time: .01 seconds
*/   
END;
/
