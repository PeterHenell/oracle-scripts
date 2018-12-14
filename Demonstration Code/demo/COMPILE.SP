CREATE OR REPLACE PROCEDURE exec_array (
   array_in   IN   DBMS_SQL.varchar2s
)
IS
   v_cur   PLS_INTEGER := DBMS_SQL.open_cursor;
BEGIN
   DBMS_SQL.parse (
      v_cur,
      array_in,
      array_in.FIRST,
      array_in.LAST,
      TRUE,
      DBMS_SQL.native
   );
   DBMS_SQL.close_cursor (v_cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_SQL.close_cursor (v_cur);
      DBMS_OUTPUT.put_line (
         'EXEC_ARRAY Failure: '
      );
      DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
END exec_array;
/

