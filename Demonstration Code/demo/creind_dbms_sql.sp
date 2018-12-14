CREATE OR REPLACE PROCEDURE create_index (
   index_in   IN   VARCHAR2,
   tab_in     IN   VARCHAR2,
   col_in     IN   VARCHAR2
)
IS
   cur             BINARY_INTEGER := DBMS_SQL.open_cursor;
   fdbk            BINARY_INTEGER;
   ddl_statement   VARCHAR2 (200)
                          := 'CREATE INDEX '
                              || index_in
                              || ' ON '
                              || tab_in
                              || ' ( '
                              || col_in
                              || ')';
BEGIN
   p.l (ddl_statement);
   DBMS_SQL.parse (cur, ddl_statement, DBMS_SQL.native);
   fdbk := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.close_cursor (cur);
END;
/
