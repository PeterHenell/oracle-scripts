CONNECT hr/hr

CREATE OR REPLACE PACKAGE analyze_memory
IS
   PROCEDURE show_memory (context_in IN VARCHAR2);

   PROCEDURE use_short (count_in    IN INTEGER,
                        length_in   IN INTEGER);

   PROCEDURE use_long (count_in    IN INTEGER,
                       length_in   IN INTEGER);

   PROCEDURE use_char (count_in    IN INTEGER,
                       length_in   IN INTEGER);
END;
/

CREATE OR REPLACE PACKAGE BODY analyze_memory
IS
   PROCEDURE show_memory (context_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (context_in);

      plsql_memory.show_memory_usage (pga_only_in => TRUE);
   END;

   PROCEDURE use_short (count_in    IN INTEGER,
                        length_in   IN INTEGER)
   IS
      TYPE short_strings_aat IS TABLE OF VARCHAR2 (3000)
         INDEX BY PLS_INTEGER;

      l_short_strings   short_strings_aat;
      l_empty           short_strings_aat;
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         l_short_strings (indx) := RPAD ('ABC', length_in, 'DEF');
      END LOOP;

      show_memory (
         '...SHORT ' || count_in || ' Length ' || length_in);
   END;

   PROCEDURE use_long (count_in    IN INTEGER,
                       length_in   IN INTEGER)
   IS
      TYPE long_strings_aat IS TABLE OF VARCHAR2 (32767)
         INDEX BY PLS_INTEGER;

      l_long_strings   long_strings_aat;
      l_empty          long_strings_aat;
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         l_long_strings (indx) := RPAD ('ABC', length_in, 'DEF');
      END LOOP;

      show_memory (
         '...LONG ' || count_in || ' Length ' || length_in);
   END;

   PROCEDURE use_char (count_in    IN INTEGER,
                       length_in   IN INTEGER)
   IS
      TYPE long_strings_aat IS TABLE OF CHAR (3000)
         INDEX BY PLS_INTEGER;

      l_long_strings   long_strings_aat;
      l_empty          long_strings_aat;
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         l_long_strings (indx) := RPAD ('ABC', length_in, 'DEF');
      END LOOP;

      show_memory (
         '...CHAR ' || count_in || ' Length ' || length_in);
   END;
END;
/

grant execute on analyze_memory to public
/

CONNECT hr/hr

SET SERVEROUTPUT ON

BEGIN
   analyze_memory.use_short (10000, 10);
END;
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

BEGIN
   hr.analyze_memory.use_long (10000, 10);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

BEGIN
   analyze_memory.use_char (10000, 10);
END;
/