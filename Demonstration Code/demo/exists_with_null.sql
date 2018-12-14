CREATE OR REPLACE PROCEDURE plch_show_boolean (val IN BOOLEAN)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE val WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE 'NULL' END);
END plch_show_boolean;
/

DECLARE
   my_list   DBMS_SQL.number_table;
   l_index   PLS_INTEGER;
BEGIN
   plch_show_boolean (my_list.EXISTS (l_index));
END;
/

DECLARE
   my_list   DBMS_SQL.number_table;
   l_index   PLS_INTEGER := 100;
BEGIN
   plch_show_boolean (my_list.EXISTS (l_index));
END;
/

DECLARE
   my_list          DBMS_SQL.number_table;
   l_index          PLS_INTEGER := 100;
   element_exists   BOOLEAN;
BEGIN
   BEGIN
      l_index := my_list (l_index);
      element_exists := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         element_exists := FALSE;
   END;

   plch_show_boolean (element_exists);
END;
/

DECLARE
   my_list   DBMS_SQL.number_table;
BEGIN
   plch_show_boolean (my_list.EXISTS (NULL));
END;
/