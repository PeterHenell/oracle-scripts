CREATE TABLE plch_tab (n NUMBER)
/

BEGIN
   INSERT INTO plch_tab
        VALUES (1);

   INSERT INTO plch_tab
        VALUES (2);

   INSERT INTO plch_tab
        VALUES (3);
END;
/

CREATE OR REPLACE PROCEDURE plch_execute (string_in IN VARCHAR2)
IS
   l_cursor     PLS_INTEGER := DBMS_SQL.open_cursor ();
   l_feedback   PLS_INTEGER;
BEGIN
   DBMS_SQL.parse (l_cursor
                 ,  'update plch_tab set n = n * 10 where n = 1'
                 ,  DBMS_SQL.native);
   l_feedback := DBMS_SQL.execute (l_cursor);
   DBMS_OUTPUT.put_line ('Result=' || l_feedback);
END;
/

BEGIN
   plch_execute ('update plch_tab set n = n * 10 where n = 1');
END;
/

BEGIN
   plch_execute ('create table plch_tab2 (n number)');
END;
/

BEGIN
   plch_execute ('select n from plch_tab where n = 2');
END;
/

BEGIN
   plch_execute ('update plch_tab set n = n * 10');
END;
/

DROP TABLE plch_tab
/

DROP TABLE plch_tab2
/

DROP PROCEDURE plch_execute
/