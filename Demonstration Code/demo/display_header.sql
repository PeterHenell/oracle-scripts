CREATE OR REPLACE PROCEDURE display_header (
   header_in             IN VARCHAR2
 , length_in             IN PLS_INTEGER DEFAULT 80
 , border_character_in   IN VARCHAR2 DEFAULT '='
 , centered_in           IN BOOLEAN DEFAULT FALSE
 , indent_in             IN PLS_INTEGER DEFAULT 0)
IS
BEGIN
   DBMS_OUTPUT.
    put_line (
      LPAD (' ', indent_in, ' ')
      || RPAD (border_character_in, length_in, border_character_in));
   DBMS_OUTPUT.
    put_line (
      LPAD (' ', indent_in, ' ')
      || CASE
            WHEN centered_in
            THEN
                  '|'
               || LPAD (' ', (length_in - LENGTH (header_in)) / 2)
               || header_in
            ELSE
               header_in
         END);
   DBMS_OUTPUT.
    put_line (
      LPAD (' ', indent_in, ' ')
      || RPAD (border_character_in, length_in, border_character_in));
END display_header;
/

BEGIN
   display_header (header_in             => 'Written by Steven Feuerstein'
                 , length_in             => 80
                 , border_character_in   => '='
                 , centered_in           => FALSE);
   display_header (header_in             => 'Written by Steven Feuerstein'
                 , length_in             => 80
                 , border_character_in   => '*'
                 , centered_in           => TRUE);
   display_header (header_in             => 'Written by Steven Feuerstein'
                 , length_in             => 40
                 , border_character_in   => '-'
                 , centered_in           => FALSE
                 , indent_in => 5);
END;
/