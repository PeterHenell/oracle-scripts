/* Formatted by PL/Formatter v.1.1.12 on 1999/02/10 19:13  (07:13 PM) */
DROP TABLE nextbook;

CREATE TABLE nextbook 
   (title VARCHAR2(100), text LONG);

DECLARE
   longval                       VARCHAR2(32767);
BEGIN
   longval :=
      RPAD ('INSTR ', 2000, 'blah1 ') ||
      RPAD ('SUBSTR ', 2000, 'blah2 ') ||
      RPAD ('TO_DATE ', 2000, 'blah3 ') ||
      RPAD ('TO_CHAR ', 2000, 'blah4 ') ||
      RPAD ('LOOP ', 2000, 'blah5 ') ||
      RPAD ('IF ', 2000, 'blah6 ') ||
      RPAD ('CURSOR ', 2000, 'blah7 ');
   
   INSERT INTO nextbook
        VALUES ('Oracle PL/SQL Quick Reference', longval);
END;
/

DECLARE
   mytab                         longcol.pieces_tt;
BEGIN
   longcol.retrieve ('nextbook', 'text', NULL, mytab);
   FOR longind IN 1 .. mytab.COUNT
   LOOP
      DBMS_OUTPUT.put_line (SUBSTR (mytab (longind), 1, 60));
   END LOOP;
END;
/