/* Single bind array */

DECLARE
   l_ids   DBMS_SQL.number_table;
BEGIN
   l_ids (1) := 138;
   l_ids (2) := 147;

   FORALL l_index IN 1 .. l_ids.COUNT
      DELETE FROM employees
            WHERE employee_id = l_ids (l_index);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   ROLLBACK;
END;
/

/* Multiple bind arrays */

DECLARE
   l_ids     DBMS_SQL.number_table;
   l_names   DBMS_SQL.varchar2a;
BEGIN
   l_ids (1) := 138;
   l_ids (2) := 147;
   l_ids (3) := 147;
   l_names (1) := 'Feuerstein';
   l_names (2) := 'Ellison';
   l_names (3) := 'Smith';

   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE employees
         SET last_name = l_names (indx)
       WHERE employee_id = l_ids (indx);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);

   ROLLBACK;
END;
/