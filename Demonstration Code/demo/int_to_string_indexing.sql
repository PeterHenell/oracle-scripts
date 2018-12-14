ALTER SESSION SET plsql_ccflags = 'INT_INDEX:true'
/

CREATE OR REPLACE PROCEDURE display_header (
   header_in             IN VARCHAR2
 , length_in             IN PLS_INTEGER DEFAULT 80
 , border_character_in   IN VARCHAR2 DEFAULT '='
 , centered_in           IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      RPAD (border_character_in, length_in, border_character_in));
   DBMS_OUTPUT.put_line (
      CASE
         WHEN centered_in
         THEN
               '|'
            || LPAD (' ', (length_in - LENGTH (header_in)) / 2)
            || header_in
         ELSE
            header_in
      END);
   DBMS_OUTPUT.put_line (
      RPAD (border_character_in, length_in, border_character_in));
END display_header;
/

CREATE OR REPLACE PROCEDURE cache_and_show (shift_by IN PLS_INTEGER)
IS
   TYPE employee_tt IS TABLE OF employees%ROWTYPE
                          INDEX BY  $IF $$int_index $THEN
                                   PLS_INTEGER;

   $ELSE                 VARCHAR2(32767);
   $END

   employee_cache   employee_tt;

   l_index           $IF $$int_index $THEN
                    PLS_INTEGER;
$ELSE                 VARCHAR2(32767);
$END
BEGIN
   display_header ('Load employees into cache indexed by ' ||  
                  $IF $$int_index $THEN 'PLS_INTEGER' 
                  $ELSE 'VARCHAR2(32767)'
                  $END
   );

   FOR rec IN (SELECT *
                 FROM employees
                WHERE ROWNUM < 5)
   LOOP
      DBMS_OUTPUT.put_line (
         'Try to load employee to index '
         || TO_CHAR (rec.employee_id + shift_by));
      employee_cache (rec.employee_id + shift_by) := rec;
      DBMS_OUTPUT.put_line ('...Load succeeded!');
   END LOOP;

   l_index := employee_cache.FIRST;

   WHILE (l_index IS NOT NULL)coll
   LOOP
      DBMS_OUTPUT.put_line (
            'Last name at index '
         || l_index
         || ' = '
         || employee_cache (l_index).last_name);
      l_index := employee_cache.NEXT (l_index);
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (
         CHR (10) || 'ERROR!!! ' || SQLERRM (SQLCODE) || CHR (10));
END cache_and_show;
/


BEGIN
   cache_and_show (2 ** 31 - 1);
END;
/

ALTER SESSION SET plsql_ccflags = 'INT_INDEX:FALSE'
/

ALTER PROCEDURE cache_and_show COMPILE
/

BEGIN
   cache_and_show (2 ** 31 - 1);
END;
/