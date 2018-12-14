DECLARE
   TYPE employees_nt IS TABLE OF employees%ROWTYPE;

   l_employees employees_nt := employees_nt ( );
BEGIN
   -- Extend a single row and set the employee name.
   l_employees.EXTEND;
   l_employees ( 1 ).last_name := 'Ellison';
   l_employees ( 1 ).first_name := 'Engleburt';
   --
   -- Extend five more rows, setting all to null.
   l_employees.EXTEND ( 5 );
   --
   -- Extend ten more rows, setting all to same as first.
   l_employees.EXTEND ( 10, 1 );

   -- Show all the names....
   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      DBMS_OUTPUT.put_line (    indx
                             || ' = '
                             || l_employees ( indx ).first_name
                             || ' '
                             || l_employees ( indx ).last_name
                           );
   END LOOP;
END;
/

DECLARE
   -- Faster to extend at once or individually?
   TYPE numbers_nt IS TABLE OF NUMBER;

   l_numbers numbers_nt := numbers_nt ( );
   l_start PLS_INTEGER;

   PROCEDURE init_test
   IS
   BEGIN
      l_numbers.DELETE;
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
   init_test;

   FOR indx IN 1 .. 10000000
   LOOP
      l_numbers.EXTEND;
   END LOOP;

   show_elapsed ( 'Individual extends' );
   --
   init_test;
   l_numbers.EXTEND ( 1000000 );
   show_elapsed ( 'Bulk extends' );
   --
   -- And when assigning a value as well?
   init_test;

   FOR indx IN 1 .. 10000000
   LOOP
      l_numbers.EXTEND;
      l_numbers ( indx ) := 3.14;
   END LOOP;

   show_elapsed ( 'Individual extends with assign of non-null initial value' );
   --
   init_test;
   l_numbers.EXTEND;
   l_numbers ( 1 ) := 3.14;
   l_numbers.EXTEND ( 10000000 - 1, 1 );
   show_elapsed ( 'Bulk extends with assign of non-null initial value' );
END;
/

/*
11.2 timings

"Individual extends" elapsed CPU time: 1.75 seconds
"Bulk extends" elapsed CPU time: .06 seconds
"Individual extends with assign of non-null initial value" elapsed CPU time: 2.22 seconds
"Bulk extends with assign of non-null initial value" elapsed CPU time: .99 seconds

*/
