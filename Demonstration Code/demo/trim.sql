DECLARE
   TYPE employees_aat IS TABLE OF employees%ROWTYPE;

   l_employees employees_aat;
BEGIN
   SELECT *
   BULK COLLECT INTO l_employees
     FROM employees;

   DBMS_OUTPUT.put_line ( 'Last index = ' || l_employees.LAST );
   -- Trim a single row.
   l_employees.TRIM;
   DBMS_OUTPUT.put_line ( 'Last index after 1 trim = ' || l_employees.LAST );
   l_employees.TRIM ( 10 );
   DBMS_OUTPUT.put_line ( 'Last index after 10 trims = ' || l_employees.LAST );
END;
/

DECLARE
   -- Faster to trim in bulk or individually?
   TYPE numbers_aat IS TABLE OF NUMBER;

   l_numbers numbers_aat := numbers_aat ( );
   l_start PLS_INTEGER;

   PROCEDURE init_test
   IS
   BEGIN
      l_start := DBMS_UTILITY.get_cpu_time;
      DBMS_SESSION.free_unused_user_memory;
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

   FOR indx IN 1 .. 10000
   LOOP
      l_numbers.TRIM;
   END LOOP;

   show_elapsed ( 'Individual trims' );
   --
   init_test;
   l_numbers.TRIM ( 10000 );
   show_elapsed ( 'Bulk trims' );
/*
11.2 timings:

"Individual trims for 1000 iterations" elapsed CPU time: .02 seconds
"Bulk trims for 1000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 10000 iterations" elapsed CPU time: .13 seconds
"Bulk trims for 10000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 50000 iterations" elapsed CPU time: 2.89 seconds
"Bulk trims for 50000 iterations" elapsed CPU time: 0 seconds
"Individual trims for 100000 iterations" elapsed CPU time: 11.97 seconds
"Bulk trims for 100000 iterations" elapsed CPU time: .01 seconds

10.2 timings

Trim 10000

"Individual trims" elapsed CPU time: .28 seconds
"Bulk trims" elapsed CPU time: 0 seconds

Trim 100000

"Individual trims" elapsed CPU time: 105.73 seconds
"Bulk trims" elapsed CPU time: .01 seconds

"Individual trims" elapsed CPU time: 77.53 seconds
"Bulk trims" elapsed CPU time: .01 seconds
*/   
END;
/
