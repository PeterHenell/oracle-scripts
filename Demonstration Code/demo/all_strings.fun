CREATE TYPE strings_t IS TABLE OF VARCHAR2 (32767);
/
CREATE OR REPLACE FUNCTION all_strings (
   tab_in IN VARCHAR2,
   col_in IN VARCHAR2,
   where_in IN VARCHAR2 := NULL
)
   RETURN strings_t
IS
   dynstr VARCHAR2 (2000);
   l_strings strings_t := strings_t ();
BEGIN
   dynstr :=
      'BEGIN
          SELECT ' || col_in ||
          ' BULK COLLECT INTO :strings ' ||
          ' FROM ' || tab_in ||
         ' WHERE ' || NVL (where_in, '1 = 1') ||
         ';
       END;';
   EXECUTE IMMEDIATE dynstr USING  OUT l_strings;
   RETURN l_strings;
END;
/
CREATE OR REPLACE PROCEDURE show_strings (strings_in IN strings_t)
IS
   indx PLS_INTEGER;
BEGIN
   indx := strings_in.FIRST;

   LOOP
      EXIT WHEN indx IS NULL;
      DBMS_OUTPUT.put_line (indx || ': ' || strings_in (indx));
      indx := strings_in.NEXT (indx);
   END LOOP;
END;
/

DECLARE 
   strings strings_t := strings_t();
BEGIN
   strings := 
      all_strings (
         'employee',
         'last_name');
   
   show_strings (strings);

   DBMS_OUTPUT.put_line ('');
   
   strings := 
      all_strings (
         'employee',
         'last_name',
         'department_id = 10');
   
   show_strings (strings);

END;
/
   