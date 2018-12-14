CREATE OR REPLACE PROCEDURE show_procs_with_parm_type (
   owner_in   IN VARCHAR2
 , type_in    IN VARCHAR2)
IS
   PROCEDURE display_header (header_in             IN VARCHAR2
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
BEGIN
   display_header ('Program Units with a ' || type_in || ' argument');

   FOR rec IN (SELECT DISTINCT package_name, object_name
                 FROM (SELECT *
                         FROM all_arguments
                        WHERE owner = owner_in AND data_type = type_in))
   LOOP
      DBMS_OUTPUT.put_line (
         CASE
            WHEN rec.package_name IS NOT NULL
            THEN
               rec.package_name || '.' || rec.object_name
            ELSE
               rec.object_name
         END);
   END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE with_long (l IN LONG)
IS
BEGIN
   DBMS_OUTPUT.put_line ('Switch to CLOB!');
END;
/

BEGIN
   show_procs_with_parm_type (USER, 'LONG');
END;
/

BEGIN
   show_procs_with_parm_type (USER, 'CHAR');
END;
/