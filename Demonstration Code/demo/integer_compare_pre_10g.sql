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
   l_my_positive pls_integer := 1;
   c_my_positive_15 CONSTANT pls_integer := 15;
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
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_number := l_number + c_number_15;
   END LOOP;

   show_elapsed_time ( 'NUMBER', DBMS_UTILITY.get_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_integer := l_integer + c_integer_15;
   END LOOP;

   show_elapsed_time ( 'INTEGER', DBMS_UTILITY.get_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_binary_integer := l_binary_integer + c_binary_integer_15;
   END LOOP;

   show_elapsed_time ( 'BINARY_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time
                     );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_pls_integer := l_pls_integer + c_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'PLS_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_positive := l_positive + c_positive_15;
   END LOOP;

   show_elapsed_time ( 'POSITIVE', DBMS_UTILITY.get_time - l_start_time );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      if l_my_positive < 1 then raise value_error ; end if;
      l_my_positive := l_my_positive + c_my_positive_15;
   END LOOP;

   show_elapsed_time ( 'MY POSITIVE', DBMS_UTILITY.get_time - l_start_time );   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_my_pls_integer := l_my_pls_integer + c_my_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'MY SUBTYPE OVER PLS_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time
                     );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_my_pkg_pls_integer := l_my_pkg_pls_integer + c_my_pkg_pls_integer_15;
   END LOOP;

   show_elapsed_time ( 'MY PKG SUBTYPE OVER PLS_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time
                     );
/*
Oracle Database 10g Release 2:

NUMBER: 1.35 seconds
INTEGER: 2.31 seconds
BINARY_INTEGER: .56 seconds
PLS_INTEGER: .57 seconds
POSITIVE: 1.08 seconds

Oracle Database 10g Release 2:

NUMBER: 1.30 seconds
INTEGER: 2.52 seconds
BINARY_INTEGER: .53 seconds
PLS_INTEGER: .52 seconds
POSITIVE: 1.00 seconds

Oracle9i Database Release 2 (slowest CPU)

NUMBER: 4.85 seconds
INTEGER: 8.39 seconds
BINARY_INTEGER: 10.24 seconds
PLS_INTEGER: 4.01 seconds
POSITIVE: 14.52 seconds

Oracle8i Database

NUMBER: 2.47 seconds
INTEGER: 3.94 seconds
BINARY_INTEGER: 6.14 seconds
PLS_INTEGER: 2.15 seconds
POSITIVE: 9.07 seconds

*/
END test_integer_performance;
/

BEGIN
   test_integer_performance;
   test_integer_performance;
   test_integer_performance;
END;
/
