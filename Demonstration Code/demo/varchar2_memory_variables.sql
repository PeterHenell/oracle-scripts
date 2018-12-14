CREATE OR REPLACE PACKAGE analzye_varchar2_memory
IS
   PROCEDURE create_proc (type_in     IN VARCHAR2,
                          length_in   IN VARCHAR2);

   PROCEDURE check_proc (type_in     IN VARCHAR2,
                         length_in   IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY analzye_varchar2_memory
IS
   PROCEDURE create_proc (type_in     IN VARCHAR2,
                          length_in   IN VARCHAR2)
   IS
      l_proc   CLOB;
   BEGIN
      l_proc :=
            'create or replace procedure chkmem_'
         || type_in
         || '_'
         || length_in
         || ' (length_in in pls_integer) is ';

      FOR indx IN 1 .. 5000
      LOOP
         l_proc :=
               l_proc
            || CHR (10)
            || type_in
            || length_in
            || '$'
            || TO_CHAR (indx)
            || ' '
            || type_in
            || '('
            || length_in
            || ');';
      END LOOP;

      l_proc := l_proc || 'BEGIN ';

      FOR indx IN 1 .. 5000
      LOOP
         l_proc :=
               l_proc
            || CHR (10)
            || type_in
            || length_in
            || '$'
            || TO_CHAR (indx)
            || ' := rpad (''abc'', 10, ''def'');';
      END LOOP;

      l_proc := l_proc || 'END; ';

      EXECUTE IMMEDIATE l_proc;
   END;

   PROCEDURE check_proc (type_in     IN VARCHAR2,
                         length_in   IN VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE
            'begin '
         || 'chkmem_'
         || type_in
         || '_'
         || length_in
         || '(10); end;';

      DBMS_OUTPUT.put_line (
            'Memory for 5000 '
         || type_in
         || ' variables max length '
         || length_in);
      plsql_memory.show_memory_usage (pga_only_in => TRUE);
   END;
END;
/

BEGIN
   analzye_varchar2_memory.create_proc ('CHAR', 3000);
   analzye_varchar2_memory.create_proc ('VARCHAR2', 3000);
   analzye_varchar2_memory.create_proc ('VARCHAR2', 32767);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

BEGIN
   analzye_varchar2_memory.check_proc ('CHAR', 3000);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

BEGIN
   analzye_varchar2_memory.check_proc ('VARCHAR2', 3000);
END;
/

CONNECT hr/hr

SET SERVEROUTPUT ON

BEGIN
   analzye_varchar2_memory.check_proc ('VARCHAR2', 32767);
END;
/