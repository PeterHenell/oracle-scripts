CONNECT scott/tiger

CREATE OR REPLACE PROCEDURE show_source (sch VARCHAR2, nm VARCHAR2)
AUTHID CURRENT_USER
IS
   TYPE str_tt IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   src   str_tt;
BEGIN
   SELECT   text
   BULK COLLECT INTO src
       FROM all_source
      WHERE owner = UPPER (sch) AND NAME = UPPER (nm)
   ORDER BY line;

   FOR indx IN src.FIRST .. src.LAST
   LOOP
      DBMS_OUTPUT.put_line (src (indx));
   END LOOP;
EXCEPTION
   WHEN VALUE_ERROR
   THEN
      DBMS_OUTPUT.put_line (   'No source code found for '
                            || sch
                            || '.'
                            || nm
                           );
END;
/

GRANT EXECUTE ON show_source TO PUBLIC;

CONNECT odev/odev
SET serveroutput on
DROP PROCEDURE temp_proc_x;

EXEC scott.show_source (user, 'temp_proc_x');

CREATE PROCEDURE temp_proc_x
IS
BEGIN
   NULL;
END;
/

EXEC scott.show_source (user, 'temp_proc_x');