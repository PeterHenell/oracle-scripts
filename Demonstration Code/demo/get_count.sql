DECLARE
   l_iterations PLS_INTEGER DEFAULT 100000;
   l_start_time PLS_INTEGER;

   PROCEDURE start_timing
   IS
   BEGIN
      l_start_time := DBMS_UTILITY.get_cpu_time;
   END start_timing;

   PROCEDURE show_elapsed ( str_in IN VARCHAR2 )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    '"'
                             || str_in
                             || '"  Elapsed CPU time: '
                             || TO_CHAR (   DBMS_UTILITY.get_cpu_time
                                          - l_start_time
                                        )
                             || ' for '
                             || l_iterations
                             || ' iterations.'
                           );
   END show_elapsed;

   PROCEDURE init_test ( str_in IN VARCHAR2 DEFAULT NULL )
   IS
   BEGIN
      start_timing;
      DBMS_OUTPUT.put_line ( str_in );
   END init_test;

   PROCEDURE finish_test ( str_in IN VARCHAR2 DEFAULT NULL )
   IS
   BEGIN
      show_elapsed ( str_in );
   END finish_test;

   PROCEDURE timing_bracket_1
   IS
      l_count PLS_INTEGER;
   BEGIN
      init_test ( 'Select COUNT(*)' );

      FOR indx IN 1 .. l_iterations
      LOOP
         SELECT COUNT ( * )
           INTO l_count
           FROM employees;
      END LOOP;

      finish_test;
   END timing_bracket_1;

   PROCEDURE timing_bracket_2
   IS
      l_count PLS_INTEGER;
   BEGIN
      init_test ( 'Statistics' );

      FOR indx IN 1 .. l_iterations
      LOOP
         SELECT num_rows
           INTO l_count
           FROM user_tab_statistics
          WHERE table_name = 'EMPLOYEES';
      END LOOP;

      finish_test;
   END timing_bracket_2;
BEGIN
   timing_bracket_1;
   timing_bracket_2;
END test_varieties;
/
