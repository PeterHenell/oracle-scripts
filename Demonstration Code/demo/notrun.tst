CREATE OR REPLACE PROCEDURE showemps (
   prefix_in IN VARCHAR2 := NULL,
   where_in IN VARCHAR2 := NULL)
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   rec employee%ROWTYPE;
   fdbk INTEGER;
   v_where VARCHAR2(1000);
BEGIN

   IF where_in IS NOT NULL
   THEN
      v_where := ' WHERE ' || where_in;
   ELSE
      v_where := NULL;
   END IF;
   
   DBMS_SQL.PARSE
     (cur, 
      'SELECT employee_id, 
              :prefix || '' '' || last_name last_name 
         FROM employee' || v_where,
      DBMS_SQL.NATIVE);

   DBMS_SQL.DEFINE_COLUMN (cur, 1, 1);
   DBMS_SQL.DEFINE_COLUMN (cur, 2, user, 30);

   DBMS_SQL.BIND_VARIABLE (cur, 'prefix', prefix_in);
   
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
SHOW ERR

BEGIN
   p.l (DBMS_PROFILER.START_PROFILER ('showemps no where clause'));
   showemps;
   p.l (DBMS_PROFILER.STOP_PROFILER);
END;   
/
@notrun SHOWEMPS


