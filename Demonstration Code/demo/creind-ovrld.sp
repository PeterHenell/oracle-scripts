create or replace PROCEDURE create_index
   (index_in IN VARCHAR2,
    tab_in IN VARCHAR2,
    col_in IN VARCHAR2)
IS
   cur BINARY_INTEGER := DBMS_SQL.OPEN_CURSOR;
   DDL_statement VARCHAR2(200)
      := 'CREATE INDEX ' || index_in ||
     ' ON ' || tab_in ||
     ' ( ' || col_in || ')';
BEGIN
   p.l (ddl_statement);
   DBMS_SQL.PARSE (cur, DDL_statement, DBMS_SQL.NATIVE);
   DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/

