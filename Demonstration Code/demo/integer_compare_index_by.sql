DECLARE
   c_iterations PLS_INTEGER := 10000000;

--
   TYPE binary_integer_aa IS TABLE OF VARCHAR2 ( 10 )
      INDEX BY BINARY_INTEGER;

   l_binary_integer_aa binary_integer_aa;

--
   TYPE pls_integer_aa IS TABLE OF VARCHAR2 ( 10 )
      INDEX BY PLS_INTEGER;

   l_pls_integer_aa pls_integer_aa;

--
   TYPE positive_aa IS TABLE OF VARCHAR2 ( 10 )
      INDEX BY PLS_INTEGER;

   l_positive_aa positive_aa;
   l_start_time PLS_INTEGER;

   PROCEDURE show_elapsed_time ( what IN VARCHAR2, t IN NUMBER )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    what
                             || ': '
                             || LTRIM ( TO_CHAR ( t / 100, '999.99' ))
                             || ' seconds'
                           );
   END;
BEGIN
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_binary_integer_aa ( MOD ( indx, 100 )) := 'abc';

      IF l_binary_integer_aa ( MOD ( indx, 100 )) = 'def'
      THEN
         NULL;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line ( l_binary_integer_aa.COUNT );
   show_elapsed_time ( 'INDEX BY BINARY_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time
                     );
   --
   l_start_time := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. c_iterations
   LOOP
      l_pls_integer_aa ( MOD ( indx, 100 )) := 'abc';

      IF l_pls_integer_aa ( MOD ( indx, 100 )) = 'def'
      THEN
         NULL;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line ( l_pls_integer_aa.COUNT );
   show_elapsed_time ( 'INDEX BY PLS_INTEGER'
                     , DBMS_UTILITY.get_time - l_start_time
                     );

   FOR indx IN 1 .. c_iterations
   LOOP
      l_positive_aa ( MOD ( indx, 100 )) := 'abc';

      IF l_positive_aa ( MOD ( indx, 100 )) = 'def'
      THEN
         NULL;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line ( l_positive_aa.COUNT );
   show_elapsed_time ( 'INDEX BY POSITIVE'
                     , DBMS_UTILITY.get_time - l_start_time
                     );
/*
Oracle9i Database Release 2

INDEX BY BINARY_INTEGER: 60.58 seconds
INDEX BY PLS_INTEGER: 57.50 seconds

On another 9iR2 machine:

INDEX BY BINARY_INTEGER: 116.54 seconds
INDEX BY PLS_INTEGER: 118.39 seconds

INDEX BY BINARY_INTEGER: 116.60 seconds
INDEX BY PLS_INTEGER: 118.58 seconds

Oracle Database 10g Release 1

INDEX BY BINARY_INTEGER: 13.76 seconds
INDEX BY PLS_INTEGER: 12.50 seconds
INDEX BY POSITIVE: 25.27 seconds

Oracle Database 10g Release 2

INDEX BY BINARY_INTEGER: 11.26 seconds
INDEX BY PLS_INTEGER: 11.12 seconds
INDEX BY POSITIVE: 22.15 seconds

*/
END;
