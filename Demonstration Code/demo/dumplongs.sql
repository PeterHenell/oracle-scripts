/* This script demonstrates how you would fetch multiple longs (ie, from
   multiple rows in a table). */

DECLARE
   TYPE pieces_tt IS TABLE OF VARCHAR2 (2000)
      INDEX BY BINARY_INTEGER;

   pieces pieces_tt;
   cur PLS_INTEGER := DBMS_SQL.open_cursor;
   fdbk PLS_INTEGER;

   TYPE long_rectype IS RECORD (
   
      piece_len                     PLS_INTEGER,
      pos_in_long                   PLS_INTEGER,
      one_piece                     VARCHAR2 (2000),
      one_piece_len                 PLS_INTEGER);

   rec long_rectype;
BEGIN
   DBMS_SQL.parse (cur, 'YOUR SELECT HERE', DBMS_SQL.native);
   DBMS_SQL.define_column_long (cur, 1);
   fdbk := DBMS_SQL.execute (cur);

   LOOP
      /* Fetch the next long value. */
      EXIT WHEN dbms_sq.fetch_rows (cur) = 0;
      rec.piece_len := 2000;
      rec.pos_in_long := 0;

      LOOP
         DBMS_SQL.column_value_long (cur,
            1,
            rec.piece_len,
            rec.pos_in_long,
            rec.one_piece,
            rec.one_piece_len
         );
         EXIT WHEN rec.one_piece_len = 0;
         pieces (NVL (pieces.LAST, 0) + 1) := rec.one_piece;
         rec.pos_in_long := rec.pos_in_long + rec.one_piece_len;
      END LOOP;

      /* Process data in pieces collection */
      NULL;                                   -- Application specific!
      /* Clear out the pieces collection for the next long. */
      pieces.delete;
   END LOOP;

   DBMS_SQL.close_cursor (cur);
END;
/
