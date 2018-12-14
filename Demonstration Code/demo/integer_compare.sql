CREATE OR REPLACE PACKAGE my_package
IS
   SUBTYPE my_pkg_pls_integer IS PLS_INTEGER;
END my_package;
/

CREATE OR REPLACE PROCEDURE test_integer_performance
IS
   c_iterations PLS_INTEGER := 10000000;
--
   l_number NUMBER := 0;
   c_number_15 CONSTANT NUMBER := 15;
--
   l_integer INTEGER := 0;
   c_integer_15 CONSTANT INTEGER := 15;
--
   l_binary_integer BINARY_INTEGER := 0;
   c_binary_integer_15 CONSTANT BINARY_INTEGER := 15;
--
   l_pls_integer PLS_INTEGER := 0;
   c_pls_integer_15 CONSTANT PLS_INTEGER := 15;
--
   l_positive POSITIVE := 1;
   c_positive_15 CONSTANT POSITIVE := 15;
--
   l_my_positive PLS_INTEGER := 1;
   c_my_positive_15 CONSTANT PLS_INTEGER := 15;

--
   SUBTYPE my_pls_integer IS PLS_INTEGER;

   l_my_pls_integer my_pls_integer := 1;
   c_my_pls_integer_15 CONSTANT my_pls_integer := 15;
--
   l_my_pkg_pls_integer my_package.my_pkg_pls_integer := 1;
   c_my_pkg_pls_integer_15 CONSTANT my_package.my_pkg_pls_integer := 15;
--
   l_start_time PLS_INTEGER;

   PROCEDURE show_elapsed_time ( what IN VARCHAR2, t IN NUMBER )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    '   '
                             || what
                             || ': '
                             || LTRIM ( TO_CHAR ( t / 100, '999.99' ))
                             || ' seconds'
                           );
   END;
BEGIN
   DBMS_OUTPUT.put_line ( 'Compare performance of various numeric types....' );
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_number := l_number + c_number_15;
   END LOOP;

   show_elapsed_time ( 'NUMBER', DBMS_UTILITY.get_cpu_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_integer := l_integer + c_integer_15;
   END LOOP;

   show_elapsed_time ( 'INTEGER', DBMS_UTILITY.get_cpu_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_binary_integer := l_binary_integer + c_binary_integer_15;
   END LOOP;

   show_elapsed_time ( 'BINARY_INTEGER'
                     , DBMS_UTILITY.get_cpu_time - l_start_time
                     );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_pls_integer := l_pls_integer + c_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'PLS_INTEGER'
                     , DBMS_UTILITY.get_cpu_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_positive := l_positive + c_positive_15;
   END LOOP;

   show_elapsed_time ( 'POSITIVE', DBMS_UTILITY.get_cpu_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      IF l_my_positive < 1
      THEN
         RAISE VALUE_ERROR;
      END IF;

      l_my_positive := l_my_positive + c_my_positive_15;
   END LOOP;

   show_elapsed_time ( 'MY POSITIVE'
                     , DBMS_UTILITY.get_cpu_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_my_pls_integer := l_my_pls_integer + c_my_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'MY SUBTYPE OVER PLS_INTEGER'
                     , DBMS_UTILITY.get_cpu_time - l_start_time
                     );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_my_pkg_pls_integer := l_my_pkg_pls_integer + c_my_pkg_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'MY PKG SUBTYPE OVER PLS_INTEGER'
                     , DBMS_UTILITY.get_cpu_time - l_start_time
                     );
/*
Oracle Database 11g Release 1:

Compare performance of various numeric types....
   NUMBER: .87 seconds
   INTEGER: 1.54 seconds
   BINARY_INTEGER: .37 seconds
   PLS_INTEGER: .38 seconds
   POSITIVE: .75 seconds
   MY POSITIVE: .87 seconds
   MY SUBTYPE OVER PLS_INTEGER: .44 seconds
   MY PKG SUBTYPE OVER PLS_INTEGER: .40 seconds
   
Oracle Database 10g Release 2:

Compare performance of various numeric types....
   NUMBER: 1.34 seconds
   INTEGER: 2.25 seconds
   BINARY_INTEGER: .55 seconds
   PLS_INTEGER: .55 seconds
   POSITIVE: 1.06 seconds
   MY POSITIVE: 1.03 seconds
   MY SUBTYPE OVER PLS_INTEGER: .56 seconds
   MY PKG SUBTYPE OVER PLS_INTEGER: .55 seconds

Oracle Database 10g Release 1:

Compare performance of various numeric types....
   NUMBER: 1.31 seconds
   INTEGER: 2.58 seconds
   BINARY_INTEGER: .52 seconds
   PLS_INTEGER: .52 seconds
   POSITIVE: .99 seconds
   MY POSITIVE: .94 seconds
   MY SUBTYPE OVER PLS_INTEGER: .52 seconds
   MY PKG SUBTYPE OVER PLS_INTEGER: .52 seconds

Oracle9i Database Release 2 (by far the slowest CPU)

Compare performance of various numeric types....
   NUMBER: 4.64 seconds
   INTEGER: 8.31 seconds
   BINARY_INTEGER: 10.10 seconds
   PLS_INTEGER: 3.79 seconds
   POSITIVE: 14.38 seconds
   MY POSITIVE: 5.67 seconds
   MY SUBTYPE OVER PLS_INTEGER: 4.00 seconds
   MY PKG SUBTYPE OVER PLS_INTEGER: 3.97 seconds

Oracle8i Database

Compare performance of various numeric types....
   NUMBER: 2.49 seconds
   INTEGER: 3.93 seconds
   BINARY_INTEGER: 6.71 seconds
   PLS_INTEGER: 2.13 seconds
   POSITIVE: 9.06 seconds
   MY POSITIVE: 2.95 seconds
   MY SUBTYPE OVER PLS_INTEGER: 2.19 seconds
   MY PKG SUBTYPE OVER PLS_INTEGER: 2.13 seconds

*/
END test_integer_performance;
/

BEGIN
   test_integer_performance;
   test_integer_performance;
   test_integer_performance;
END;
/
