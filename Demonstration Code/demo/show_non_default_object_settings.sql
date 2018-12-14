CREATE OR REPLACE PROCEDURE show_object_settings (
   owner_in IN VARCHAR2 DEFAULT USER
)
IS
   PROCEDURE display_header (header_in           IN VARCHAR2
                           , length_in           IN PLS_INTEGER DEFAULT 80
                           , border_character_in IN VARCHAR2 DEFAULT '='
                           , centered_in         IN BOOLEAN DEFAULT FALSE
                            )
   IS
   BEGIN
      DBMS_OUTPUT.
       put_line (RPAD (border_character_in, length_in, border_character_in));
      DBMS_OUTPUT.
       put_line (
         CASE
            WHEN centered_in
            THEN
                  '|'
               || LPAD (' ', (length_in - LENGTH (header_in)) / 2)
               || header_in
            ELSE
               header_in
         END
      );
      DBMS_OUTPUT.
       put_line (RPAD (border_character_in, length_in, border_character_in));
   END display_header;

   PROCEDURE show_setting (NAME_IN          IN VARCHAR2
                         , value_in         IN VARCHAR2
                         , check_against_in IN VARCHAR2 DEFAULT NULL
                          )
   IS
   BEGIN
      IF (check_against_in IS NOT NULL
          AND NVL (value_in <> check_against_in, TRUE))
         OR (check_against_in IS NULL AND value_in IS NOT NULL)
      THEN
         DBMS_OUTPUT.put_line ('>  ' || NAME_IN || ' = ' || value_in);
      END IF;
   END show_setting;
BEGIN
   FOR program_rec
      IN (SELECT *
            FROM all_plsql_object_settings pos
           WHERE owner = owner_in
                 AND (   pos.plsql_optimize_level <> 2
                      OR pos.plsql_code_type <> 'INTERPRETED'
                      OR pos.plsql_debug <> 'FALSE'
                      OR pos.plsql_warnings <> 'DISABLE:ALL'
                      OR pos.plsql_ccflags IS NOT NULL
                      OR pos.plscope_settings <> 'IDENTIFIERS:NONE')
          ORDER BY owner, name)
   LOOP
      display_header (
            program_rec.TYPE
         || ' '
         || program_rec.owner
         || '.'
         || program_rec.name
      );
      show_setting ('Optimization Level'
                  , program_rec.plsql_optimize_level
                  , 2
                   );
      show_setting ('Code Type', program_rec.plsql_code_type, 'INTERPRETED');
      show_setting ('Debug Setting', program_rec.plsql_debug, 'FALSE');
      show_setting ('Warnings Setting'
                  , program_rec.plsql_warnings
                  , 'DISABLE:ALL'
                   );
      show_setting ('CCFlags Setting', program_rec.plsql_ccflags);
      show_setting ('PL/Scope Setting'
                  , program_rec.plscope_settings
                  , 'IDENTIFIERS:NONE'
                   );
   END LOOP;
END show_object_settings;
/

BEGIN
   show_object_settings;
END;
/