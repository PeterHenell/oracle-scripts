CREATE OR REPLACE PROCEDURE show_query (query_in IN VARCHAR2)
AUTHID CURRENT_USER
IS
   l_cursor    PLS_INTEGER;
   l_columns   DBMS_SQL.desc_tab2;
   l_count     PLS_INTEGER;

   PROCEDURE cleanup
   IS
   BEGIN
      IF DBMS_SQL.is_open (g_cursor)
      THEN
         DBMS_SQL.close_cursor (g_cursor);
      END IF;
   END cleanup;
BEGIN
   DBMS_SQL.parse (l_cursor, query_in, DBMS_SQL.native);
   DBMS_SQL.describe_columns (l_cursor, l_columns, l_count);
   cleanup;
EXCEPTION
   WHEN OTHERS
   THEN
      cleanup;
      RAISE;
END show_query;
/