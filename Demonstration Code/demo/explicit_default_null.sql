CREATE OR REPLACE PROCEDURE default_null
IS
   l_value   PLS_INTEGER;
BEGIN
   NULL;
END default_null;
/

CREATE OR REPLACE PROCEDURE explicit_null
IS
   l_value   PLS_INTEGER := NULL;
BEGIN
   NULL;
END explicit_null;
/

CREATE OR REPLACE PROCEDURE test_varieties (
   iterations_in    IN   PLS_INTEGER DEFAULT 1
 , show_timing_in   IN   BOOLEAN DEFAULT FALSE
)
IS
   l_start_time   PLS_INTEGER;

   PROCEDURE start_timing
   IS
   BEGIN
      l_start_time := DBMS_UTILITY.get_cpu_time;
   END start_timing;

   PROCEDURE show_elapsed (str_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   '"'
                            || str_in
                            || '"  Elapsed CPU time: '
                            || TO_CHAR (  DBMS_UTILITY.get_cpu_time
                                        - l_start_time
                                       )
                           );
   END show_elapsed;

   PROCEDURE init_test (str_in IN VARCHAR2 DEFAULT NULL)
   IS
   BEGIN
      IF show_timing_in
      THEN
         start_timing;
      END IF;

      IF str_in IS NOT NULL
      THEN
         DBMS_OUTPUT.put_line (str_in);
      END IF;
   END init_test;

   PROCEDURE finish_test (str_in IN VARCHAR2)
   IS
   BEGIN
      IF show_timing_in
      THEN
         show_elapsed (str_in);
      END IF;
   END finish_test;

   PROCEDURE test1
   IS
   BEGIN
      init_test;

      FOR indx IN 1 .. iterations_in
      LOOP
         default_null;
      END LOOP;

      finish_test ('Rely on default NULL');
   END test1;

   PROCEDURE test2
   IS
   BEGIN
      init_test;

      FOR indx IN 1 .. iterations_in
      LOOP
         explicit_null;
      END LOOP;

      finish_test ('Assign NULL explicitly');
   END test2;
BEGIN
   test1;
   test2;
END test_varieties;
/

BEGIN
   test_varieties (10000000, TRUE);
/*
Oracle Database 10g Release 1

"Rely on default NULL"  Elapsed CPU time: 344
"Assign NULL explicitly"  Elapsed CPU time: 339

"Rely on default NULL"  Elapsed CPU time: 337
"Assign NULL explicitly"  Elapsed CPU time: 341

Oracle Database 9i Release 2

"Rely on default NULL"  Elapsed CPU time: 1365
"Assign NULL explicitly"  Elapsed CPU time: 1678

Oracle Database 8i

"Rely on default NULL"  Elapsed CPU time: 677
"Assign NULL explicitly"  Elapsed CPU time: 805
*/
END;
/
