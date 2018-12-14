CREATE OR REPLACE PROCEDURE open_parse_cursor (
   security_level_in   IN     PLS_INTEGER
 , cursor_out          IN OUT NUMBER)
   AUTHID CURRENT_USER
IS
BEGIN
   cursor_out := DBMS_SQL.open_cursor (security_level_in);
   DBMS_SQL.parse (cursor_out
                 , 'update employees set last_name = last_name || NULL'
                 , DBMS_SQL.native);
END;
/

CREATE OR REPLACE PROCEDURE exec_cursor (cur_in IN NUMBER)
AUTHID DEFINER
IS
   fdbk   PLS_INTEGER;
BEGIN
   fdbk := DBMS_SQL.execute (cur_in);
END;
/

DECLARE
   cur   PLS_INTEGER;
BEGIN
   BEGIN
      DBMS_OUTPUT.put_line ('Don''t pass a security level - pre 11g');
      cur := DBMS_SQL.open_cursor ();
      DBMS_SQL.close_cursor (cur);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());
   END;

   BEGIN
      DBMS_OUTPUT.put_line ('Set to level 0');
      cur := DBMS_SQL.open_cursor (0);
      DBMS_SQL.close_cursor (cur);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());
   END;

   BEGIN
      DBMS_OUTPUT.put_line ('Set to level 1 and call definer rights program');
      open_parse_cursor (1, cur);
      exec_cursor (cur);
      ROLLBACK;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());
   END;
END;
/