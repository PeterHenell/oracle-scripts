/* Formatted by PL/Formatter v3.0.5.0 on 2000/06/18 06:38 */

CREATE OR REPLACE PROCEDURE showemps (
   where_in IN VARCHAR2 := NULL
)
IS
   cur INTEGER := DBMS_SQL.open_cursor;
   rec employee%ROWTYPE;
   fdbk INTEGER;
BEGIN
   DBMS_SQL.parse (
      cur,
      'select employee_id, last_name from employee ' ||
         ' where ' ||
         NVL (where_in, '1=1'),
      DBMS_SQL.native
   );
   DBMS_SQL.define_column (cur, 1, 1);
   DBMS_SQL.define_column (cur, 2, USER, 30);
   fdbk := DBMS_SQL.execute (cur);

   LOOP
/* fetch next row. exit when done. */
      EXIT WHEN DBMS_SQL.fetch_rows (cur) = 0;
      DBMS_SQL.column_value (cur, 1, rec.employee_id);
      DBMS_SQL.column_value (cur, 2, rec.last_name);
      p.l (TO_CHAR (rec.employee_id) || '=' || rec.last_name);
   END LOOP;

   DBMS_SQL.close_cursor (cur);
END;
/

CREATE OR REPLACE PROCEDURE showemps (
   where_in IN VARCHAR2 := NULL
)
IS
   cur INTEGER
/*PLF(6): Consider using PLS_INTEGER instead of INTEGER
              and BINARY_INTEGER if on Oracle 7.3 or above
              [302] */
               := DBMS_SQL.open_cursor;
   rec employee%ROWTYPE;
   fdbk INTEGER
/*PLF(12): Consider using PLS_INTEGER instead of INTEGER
              and BINARY_INTEGER if on Oracle 7.3 or above
              [302] */
               ;
BEGIN
   DBMS_SQL.parse (
      cur,
      'select employee_id, last_name from employee ' ||
         ' where ' ||
         NVL (where_in, '1=1'),
      DBMS_SQL.native
   );
   DBMS_SQL.define_column (cur, 1, 1);
   DBMS_SQL.define_column (cur, 2, USER, 30);
   fdbk := DBMS_SQL.execute (cur);

   LOOP
/* fetch next row. exit when done. */
      EXIT WHEN DBMS_SQL.fetch_rows (cur) = 0;
      DBMS_SQL.column_value (cur, 1, rec.employee_id);
      DBMS_SQL.column_value (cur, 2, rec.last_name);
      p.l (TO_CHAR (rec.employee_id) || '=' || rec.last_name);
   END LOOP;

   DBMS_SQL.close_cursor (cur);
END;
/
/*PLF(39): END of program unit, package or type is not
              labeled [408] */