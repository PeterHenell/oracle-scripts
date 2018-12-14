CREATE OR REPLACE PROCEDURE display_clob (
   clob_in          IN CLOB
 , append_in        IN BOOLEAN DEFAULT TRUE
 , preserve_code_in IN BOOLEAN DEFAULT FALSE
)
IS
   l_lines   DBMS_SQL.varchar2s;

   PROCEDURE clob_to_code_lines (clob_in     IN            CLOB
                               , lines_inout IN OUT NOCOPY DBMS_SQL.varchar2s
                                )
   IS
      c_array_max         CONSTANT PLS_INTEGER DEFAULT 250;
      c_delim_not_found   CONSTANT PLS_INTEGER DEFAULT 99999999;
      c_length            CONSTANT PLS_INTEGER := LENGTH (clob_in);
      l_string            VARCHAR2 (255);
      l_start             PLS_INTEGER := 1;
      l_latest_delim      PLS_INTEGER;

      TYPE delims_t IS TABLE OF VARCHAR2 (1);

      l_delims            delims_t := delims_t (' ', ';', CHR (10));

      FUNCTION latest_delim (string_in IN CLOB, start_in IN PLS_INTEGER)
         RETURN PLS_INTEGER
      IS
         l_string VARCHAR2 (32767)
               := SUBSTR (string_in, start_in, c_array_max);
         l_location    PLS_INTEGER := c_delim_not_found;
         l_delim_loc   PLS_INTEGER;
      BEGIN
         /* The string fits within the limits */
         IF LENGTH (l_string) < c_array_max
         THEN
            l_location := 0;
         ELSE
            /* Find the location of the last delimiter that falls before the 255 limit
                                          and use that to break up the string. */
            FOR indx IN 1 .. l_delims.COUNT
            LOOP
               l_delim_loc := INSTR (l_string, l_delims (indx), -1, 1);

               IF l_delim_loc > 0
               THEN
                  l_location := LEAST (l_location, l_delim_loc);
               END IF;
            END LOOP;

            /* If a location was found, then shift it back into the bigger string. */
            IF l_location > 0
            THEN
               l_location := l_location + start_in - 1;
            END IF;
         END IF;

         RETURN l_location;
      END latest_delim;
   BEGIN
      IF NOT append_in
      THEN
         lines_inout.delete;
      END IF;

      WHILE (l_start <= c_length)
      LOOP
         IF preserve_code_in
         THEN
            /* Do more complex parsing. */
            l_latest_delim := latest_delim (clob_in, l_start);

            -- l_next_lf := INSTR (string_in, CHR (10), l_start);
            IF l_latest_delim = c_delim_not_found
            THEN
               /* No delimiter found.*/
               IF c_length - l_start + 1 > c_array_max
               THEN
                  raise_application_error (
                     -20000
                   , 'Unable to parse a CLOB without delimiters - string block too long.'
                  );
               ELSE
                  l_string :=
                     SUBSTR (clob_in, l_start, c_array_max + l_start - 1);
                  l_start := l_start + c_array_max;
               END IF;
            ELSIF l_latest_delim > 0
            THEN
               l_string :=
                  SUBSTR (clob_in, l_start, l_latest_delim - l_start + 1);
               l_start := l_latest_delim + 1;
            ELSE
               l_string :=
                  SUBSTR (clob_in, l_start, c_array_max + l_start - 1);
               l_start := l_start + c_array_max;
            END IF;
         ELSE
            /* Just break up the line at the c_array_max */
            l_string := SUBSTR (clob_in, l_start, c_array_max);
            l_start := l_start + c_array_max;
         END IF;

         lines_inout (lines_inout.COUNT + 1) := l_string;
      END LOOP;
   END clob_to_code_lines;
BEGIN
   clob_to_code_lines (clob_in, l_lines);

   FOR indx IN 1 .. l_lines.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_lines (indx));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND OR VALUE_ERROR
   THEN
      /* All done! */
      NULL;
END display_clob;
/

BEGIN
   display_clob('CREATE OR REPLACE PROCEDURE display_clob (
   clob_in          IN CLOB
 , append_in        IN BOOLEAN DEFAULT TRUE
 , preserve_code_in IN BOOLEAN DEFAULT FALSE
)
IS
   l_lines   DBMS_SQL.varchar2s;

   PROCEDURE clob_to_code_lines (clob_in     IN            CLOB
                               , lines_inout IN OUT NOCOPY DBMS_SQL.varchar2s
                                )
   IS
      c_array_max         CONSTANT PLS_INTEGER DEFAULT 250;
      c_delim_not_found   CONSTANT PLS_INTEGER DEFAULT 99999999;
      c_length            CONSTANT PLS_INTEGER := LENGTH (clob_in);
      l_string            VARCHAR2 (255);
      l_start             PLS_INTEGER := 1;
      l_latest_delim      PLS_INTEGER;

      TYPE delims_t IS TABLE OF VARCHAR2 (1);

      l_delims            delims_t := delims_t ('''', '';'', CHR (10));

      FUNCTION latest_delim (string_in IN CLOB, start_in IN PLS_INTEGER)
         RETURN PLS_INTEGER
      IS
         l_string VARCHAR2 (32767)
               := SUBSTR (string_in, start_in, c_array_max);
         l_location    PLS_INTEGER := c_delim_not_found;
         l_delim_loc   PLS_INTEGER;
      BEGIN
         /* The string fits within the limits */
         IF LENGTH (l_string) < c_array_max
         THEN
            l_location := 0;
         ELSE
            /* Find the location of the last delimiter that falls before the 255 limit
                                          and use that to break up the string. */
            FOR indx IN 1 .. l_delims.COUNT
            LOOP
               l_delim_loc := INSTR (l_string, l_delims (indx), -1, 1);

               IF l_delim_loc > 0
               THEN
                  l_location := LEAST (l_location, l_delim_loc);
               END IF;
            END LOOP;

            /* If a location was found, then shift it back into the bigger string. */
            IF l_location > 0
            THEN
               l_location := l_location + start_in - 1;
            END IF;
         END IF;

         RETURN l_location;
      END latest_delim;
   BEGIN
      IF NOT append_in
      THEN
         lines_inout.delete;
      END IF;

      WHILE (l_start <= c_length)
      LOOP
         IF preserve_code_in
         THEN
            /* Do more complex parsing. */
            l_latest_delim := latest_delim (clob_in, l_start);

            -- l_next_lf := INSTR (string_in, CHR (10), l_start);
            IF l_latest_delim = c_delim_not_found
            THEN
               /* No delimiter found.*/
               IF c_length - l_start + 1 > c_array_max
               THEN
                  raise_application_error (
                     -20000
                   , ''Unable to parse a CLOB without delimiters - string block too long.''
                  );
               ELSE
                  l_string :=
                     SUBSTR (clob_in, l_start, c_array_max + l_start - 1);
                  l_start := l_start + c_array_max;
               END IF;
            ELSIF l_latest_delim > 0
            THEN
               l_string :=
                  SUBSTR (clob_in, l_start, l_latest_delim - l_start + 1);
               l_start := l_latest_delim + 1;
            ELSE
               l_string :=
                  SUBSTR (clob_in, l_start, c_array_max + l_start - 1);
               l_start := l_start + c_array_max;
            END IF;
         ELSE
            /* Just break up the line at the c_array_max */
            l_string := SUBSTR (clob_in, l_start, c_array_max);
            l_start := l_start + c_array_max;
         END IF;

         lines_inout (lines_inout.COUNT + 1) := l_string;
      END LOOP;
   END clob_to_code_lines;
BEGIN
   clob_to_code_lines (clob_in, l_lines);

   FOR indx IN 1 .. l_lines.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_lines (indx));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND OR VALUE_ERROR
   THEN
      /* All done! */
      NULL;
END display_clob;');
END;
/