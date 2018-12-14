---------- find_col.sql -------------------
SET pagesize 0;
SELECT SUBSTR(t.owner||'.'||t.table_name,1,45) AS table_name, c.column_name
  FROM all_tables t, all_tab_columns c
 WHERE t.table_name = c.table_name
   AND column_name LIKE UPPER('%&Column_Name%')
ORDER BY 1
/
----------------------------------------
