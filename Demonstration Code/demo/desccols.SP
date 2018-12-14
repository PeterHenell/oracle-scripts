CREATE OR REPLACE PROCEDURE show_columns (my_query IN VARCHAR2)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   cols DBMS_SQL.DESC_TAB;
   ncols PLS_INTEGER;
BEGIN
   DBMS_SQL.PARSE (cur, my_query, DBMS_SQL.NATIVE);

   DBMS_SQL.DESCRIBE_COLUMNS (cur, ncols, cols);

   FOR colind IN 1 .. ncols
   LOOP
      p.l (cols(colind).col_name, cols(colind).col_type);
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/