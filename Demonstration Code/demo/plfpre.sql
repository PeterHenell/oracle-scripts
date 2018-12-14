create or replace procedure showemps (where_in in 
   varchar2 := null)
is
cur integer := dbms_sql.open_cursor;
rec employee%rowtype;
fdbk integer;
begin

dbms_sql.parse
(cur, 'select employee_id, last_name from employee ' || 
     ' where ' || nvl (where_in, '1=1'),
dbms_sql.native);

dbms_sql.define_column (cur, 1, 1);
dbms_sql.define_column (cur, 2, user, 30);

fdbk := dbms_sql.execute (cur);
loop
/* fetch next row. exit when done. */
exit when dbms_sql.fetch_rows (cur) = 0;
dbms_sql.column_value (cur, 1, rec.employee_id);
dbms_sql.column_value (cur, 2, rec.last_name);
p.l (to_char (rec.employee_id) || '=' || rec.last_name);
end loop;

dbms_sql.close_cursor (cur);
end;
/

