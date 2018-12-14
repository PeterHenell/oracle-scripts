CREATE OR REPLACE PROCEDURE showemps (
   numcol IN VARCHAR2,
   strcol IN VARCHAR2,
   where_in IN VARCHAR2 := NULL)
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   rec employee%ROWTYPE;
   fdbk INTEGER;
   loc INTEGER;
BEGIN

   DBMS_SQL.PARSE
     (cur, 'SELECT ' || numcol || ', ' || strcol || 
            ' FROM employee ' || 
           ' WHERE ' || NVL (where_in, '1=1'),
      DBMS_SQL.NATIVE);

   DBMS_SQL.DEFINE_COLUMN (cur, 1, 1);
   DBMS_SQL.DEFINE_COLUMN (cur, 2, 'a', 30);

   /* Assumes that you are passing a single bind variable
      for a numeric column, but it will figure out the 
      name of the bind variable. Rule: must appear at end
      of string. */

   loc := INSTR (where_in, ':');

   DBMS_SQL.BIND_VARIABLE (cur, SUBSTR (where_in, loc+1), 10);

   fdbk := DBMS_SQL.EXECUTE (cur);
   LOOP
      /* Fetch next row. Exit when done. */
      EXIT WHEN DBMS_SQL.FETCH_ROWS (cur) = 0;
      DBMS_SQL.COLUMN_VALUE (cur, 1, rec.employee_id);
      DBMS_SQL.COLUMN_VALUE (cur, 2, rec.last_name);
      p.l (TO_CHAR (rec.employee_id) || '=' || rec.last_name);
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/

