/* Formatted on 2007/08/23 18:28 (Formatter Plus v4.8.8) */
DECLARE
   c_iterations                   PLS_INTEGER    := 10000000;
   l_pls_integer                  PLS_INTEGER    := 1;
   c_pls_integer_15      CONSTANT PLS_INTEGER    := 15;
--
   l_simple_integer               simple_integer := 1;
   c_simple_integer_15   CONSTANT simple_integer := 15;
   l_start_time                   PLS_INTEGER;

   PROCEDURE show_elapsed_time (what IN VARCHAR2, t IN NUMBER)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   '   '
                            || what
                            || ': '
                            || LTRIM (TO_CHAR (t / 100, '999.99'))
                            || ' seconds'
                           );
   END;
BEGIN
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_pls_integer :=
           (10000000 / (2 * l_pls_integer)) * .75 + MOD (c_pls_integer_15, 2);
   END LOOP;

   show_elapsed_time ('PLS_INTEGER', DBMS_UTILITY.get_cpu_time - l_start_time);
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_simple_integer :=
           (10000000 / (2 * l_simple_integer)) * .75
         + MOD (c_simple_integer_15, 2);
   END LOOP;

   show_elapsed_time ('SIMPLE_INTEGER',
                      DBMS_UTILITY.get_cpu_time - l_start_time
                     );
/*
PLS_INTEGER: 7.41 seconds
SIMPLE_INTEGER: 7.64 seconds
*/                     
END test_integer_performance;
/