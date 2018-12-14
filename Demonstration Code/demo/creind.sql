CREATE OR REPLACE PROCEDURE create_index (
   index_in   IN   VARCHAR2
 , tab_in     IN   VARCHAR2
 , col_in     IN   VARCHAR2
)
IS
   cur             INTEGER        := DBMS_SQL.open_cursor;
   ddl_statement   VARCHAR2 (200)
      := 'CREATE INDEX ' || index_in || ' ON ' || tab_in || ' ( ' || col_in
         || ')';
BEGIN
   DBMS_SQL.parse (cur, ddl_statement, DBMS_SQL.v7);
END;
/