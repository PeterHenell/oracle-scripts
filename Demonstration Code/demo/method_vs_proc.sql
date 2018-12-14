DECLARE
   l_list DBMS_SQL.number_table;
BEGIN
   l_list.DELETE;

   DELETE (l_list);
END;