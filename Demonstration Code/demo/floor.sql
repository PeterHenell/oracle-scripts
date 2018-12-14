DECLARE
   l_values   DBMS_SQL.number_table;
   l_index    PLS_INTEGER;
BEGIN
   FOR indx IN 1 .. 10
   LOOP
      l_values (FLOOR (1 + indx / 10)) := 100;
   END LOOP;

   l_index := l_values.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      sys.DBMS_OUTPUT.put_line (l_values (l_index));
      l_index := l_values.NEXT (l_index);
   END LOOP;
END;
/
