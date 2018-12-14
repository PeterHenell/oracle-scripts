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

   PROCEDURE show_elapsed (str IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   '"'
                            || str
                            || '"  Elapsed CPU time: '
                            || TO_CHAR (  DBMS_UTILITY.get_cpu_time
                                        - l_start_time
                                       )
                           );
   END show_elapsed;

   PROCEDURE init_test (str_in IN VARCHAR2)
   IS
   BEGIN
      IF show_timing_in
      THEN
         start_timing;
      END IF;

      DBMS_OUTPUT.put_line (str_in);
   END init_test;

   PROCEDURE finish_test (str_in IN VARCHAR2)
   IS
   BEGIN
      IF show_timing_in
      THEN
         show_elapsed (str);
      END IF;
   END finish_test;

   PROCEDURE test1
   IS
      l_cv    sys_refcursor;
      l_one   in_clause_tab%ROWTYPE;
   BEGIN
      init_test ('Output from NDS_LIST');

      FOR indx IN 1 .. iterations_in
      LOOP
         l_cv := nds_list ('1,3');

         LOOP
            FETCH l_cv
             INTO l_one;

            EXIT WHEN l_cv%NOTFOUND;

            IF indx = 1
            THEN
               DBMS_OUTPUT.put_line ('  ' || l_one.title);
            END IF;
         END LOOP;

         CLOSE l_cv;
      END LOOP;

      finish_test;
   END test1;
BEGIN
   test1;
END test_varieties;
/