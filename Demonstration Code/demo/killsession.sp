CREATE OR REPLACE PROCEDURE killsession (
   sessionid      IN   NUMBER,
   serialnumber   IN   NUMBER
)
IS
   c   INTEGER := DBMS_SQL.open_cursor;
   i   INTEGER;
BEGIN
   DBMS_SQL.parse (
      c,
      'ALTER SYSTEM KILL SESSION ''' ||
         sessionid ||
         ',' ||
         serialnumber ||
         '''',
      DBMS_SQL.native
   );
   i := DBMS_SQL.execute (c);
END;
/
