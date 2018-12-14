CREATE OR REPLACE PROCEDURE alt_rbseg (action_in IN VARCHAR2)
IS
   my_stmt VARCHAR2 (1000);
   cursor_handle INTEGER;
   rbseg_altered INTEGER;
   rbseg_status dba_rollback_segs.status%TYPE;
BEGIN
   cursor_handle := DBMS_SQL.open_cursor;
   SELECT status
     INTO rbseg_status
     FROM dba_rollback_segs
    WHERE segment_name = 'R04';

   IF rbseg_status != UPPER (action_in)
   THEN
      my_stmt := 'ALTER ROLLBACK SEGMENT R04 ' || action_in;
      DBMS_SQL.parse (cursor_handle, my_stmt, DBMS_SQL.v7);
      rbseg_altered := DBMS_SQL.execute (cursor_handle);
      DBMS_SQL.close_cursor (cursor_handle);
   END IF;

   IF UPPER (action_in) = 'ONLINE'
   THEN
      COMMIT;
      DBMS_TRANSACTION.use_rollback_segment ('R04');
   END IF;
END alt_rbseg;
/
