DECLARE
   l_string1 VARCHAR2 ( 32767 );
   l_string2 VARCHAR2 ( 32767 );
   l_string3 VARCHAR2 ( 32767 );
   l_string4 VARCHAR2 ( 32767 );
   l_string5 VARCHAR2 ( 32767 );
BEGIN
   DBMS_SESSION.free_unused_user_memory;
   --
   my_session.MEMORY;
   l_string1 := RPAD ( 'abc', 32767, 'x' );
   l_string2 := RPAD ( 'abc', 32767, 'x' );
   l_string3 := RPAD ( 'abc', 32767, 'x' );
   l_string4 := RPAD ( 'abc', 32767, 'x' );
   l_string5 := RPAD ( 'abc', 32767, 'x' );
   my_session.MEMORY;
END;
/

DECLARE
   TYPE strings_aat IS TABLE OF VARCHAR2 ( 32767 )
      INDEX BY PLS_INTEGER;

   l_strings strings_aat;
   --
   l_gap PLS_INTEGER := 100000;
BEGIN
   DBMS_SESSION.free_unused_user_memory;
   my_session.MEMORY;

   FOR i IN 1 .. 1000
   LOOP
      l_strings ( i ) := TO_CHAR ( i );
      l_strings ( i + 1 * l_gap ) := TO_CHAR ( i );
      l_strings ( i + 2 * l_gap ) := TO_CHAR ( i );
      l_strings ( i + 3 * l_gap ) := TO_CHAR ( i );
      l_strings ( i + 4 * l_gap ) := TO_CHAR ( i );
      l_strings ( i + 5 * l_gap ) := TO_CHAR ( i );
   END LOOP;

   DBMS_OUTPUT.put_line ( l_strings.COUNT );
   my_session.MEMORY;
END;
/
