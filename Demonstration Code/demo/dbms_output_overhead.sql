DROP TABLE overhead_results
/
CREATE TABLE overhead_results (
   text VARCHAR2(1000)
   )
/
SET serveroutput on size unlimited format wrapped

CREATE OR REPLACE PROCEDURE test_do_overhead (
   counter_in   IN   PLS_INTEGER
 , length_in    IN   PLS_INTEGER
)
IS
   l_start PLS_INTEGER;
   l_end PLS_INTEGER;
   l_string VARCHAR2 ( 100 );
   l_boolean BOOLEAN := TRUE;

   PROCEDURE record_results (
      start_in     IN   PLS_INTEGER
    , end_in       IN   PLS_INTEGER
    , counter_in   IN   PLS_INTEGER
    , length_in    IN   PLS_INTEGER
    , text_in      IN   VARCHAR2
   )
   IS
   BEGIN
      INSERT INTO overhead_results
           VALUES (    text_in
                    || CASE
                          WHEN length_in IS NULL
                             THEN NULL
                          ELSE ' RPAD to ' || length_in
                       END
                    || ' X '
                    || counter_in
                    || '-Elapsed time = '
                    || TO_CHAR ( end_in - start_in ));

      COMMIT;
   END record_results;

   PROCEDURE call_output_program
   IS
   BEGIN
      l_start := DBMS_UTILITY.get_cpu_time ( );

      FOR indx IN 1 .. counter_in
      LOOP
         DBMS_OUTPUT.put_line (    RPAD ( 'Overhead', length_in, 'x' )
                                || '-'
                                || TO_CHAR ( SYSDATE )
                                || '-'
                                || CASE
                                      WHEN l_boolean
                                         THEN 'TRUE'
                                      WHEN NOT l_boolean
                                         THEN 'FALSE'
                                      ELSE 'NULL'
                                   END
                              );
         l_string := SUBSTR ( 'Steven Feuerstein', 5, 5 );
         l_end := DBMS_UTILITY.get_cpu_time ( );
      END LOOP;
   END call_output_program;
BEGIN
   -- With output enabled (assumed to be done externally, unlimited buffer size)
   call_output_program;
   record_results ( l_start
                  , l_end
                  , counter_in
                  , length_in
                  , 'With DBMS_OUTPUT enabled'
                  );
   -- With output disabled
   DBMS_OUTPUT.DISABLE;
   call_output_program;
   record_results ( l_start
                  , l_end
                  , counter_in
                  , length_in
                  , 'With DBMS_OUTPUT disabled'
                  );
   -- With output disabled and passing NULL
   DBMS_OUTPUT.DISABLE;
   l_start := DBMS_UTILITY.get_cpu_time ( );

   FOR indx IN 1 .. counter_in
   LOOP
      DBMS_OUTPUT.put_line ( NULL );
      l_string := SUBSTR ( 'Steven Feuerstein', 5, 5 );
   END LOOP;

   l_end := DBMS_UTILITY.get_cpu_time ( );
   record_results ( l_start
                  , l_end
                  , counter_in
                  , NULL
                  , 'With DBMS_OUTPUT disabled and passing NULL'
                  );
   -- Without DBMS_OUTPUT
   l_start := DBMS_UTILITY.get_cpu_time ( );

   FOR indx IN 1 .. counter_in
   LOOP
      l_string := SUBSTR ( 'Steven Feuerstein', 5, 5 );
   END LOOP;

   l_end := DBMS_UTILITY.get_cpu_time ( );
   record_results ( l_start, l_end, counter_in, NULL, 'Without DBMS_OUTPUT' );
END;
/

BEGIN
   test_do_overhead ( 1000000, 10 );
   test_do_overhead ( 1000000, 10000 );
/*
With DBMS_OUTPUT enabled RPAD to 10 X 1000000-Elapsed time = 773
With DBMS_OUTPUT disabled RPAD to 10 X 1000000-Elapsed time = 413
Without DBMS_OUTPUT RPAD to 10 X 1000000-Elapsed time = 11

With DBMS_OUTPUT enabled RPAD to 10000 X 1000000-Elapsed time = 756
With DBMS_OUTPUT disabled RPAD to 10000 X 1000000-Elapsed time = 755
Without DBMS_OUTPUT RPAD to 10000 X 1000000-Elapsed time = 13
*/
END;
/

SELECT *
  FROM overhead_results
/
