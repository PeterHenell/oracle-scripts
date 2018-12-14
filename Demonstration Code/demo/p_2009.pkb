CREATE OR REPLACE PACKAGE BODY p
/*----------------------------------------------------------------
|| Author: Steven Feuerstein
||
|| The p package is my "replacement" for DBMS_OUTPUT.PUT_LINE.
||
|| Key advantages: lots of overloadings to support combinations
||                 of datatypes and types not supported at all by
||                 the built-in. Also, you only have to type 3
||                 characters to command "show me".
-----------------------------------------------------------------*/

/*

Updated October 2009 in response to various recommendations from
readers. Key changes:

- Got rid of turn_on/turn_off and the show_in parameter. This is
now a simpler layer of code on top of DBMS_OUTPUT.PUT_LINE. If
server output is enabled, you see the output, else it is ignored.
Just like DBMS_OUTPUT.

- Refactored overloadings so that you never need to use named
notation to call p.l

- No more prefix. You should SET SERVEROUTPUT ON FORMAT WRAPPED
if you don't want to lose leading blanks.

- Set the date format mask once, per session, via a program call,
rather than by passing it in the parameter list (which complicates
the overloadings).

*/

IS
   g_line_length   PLS_INTEGER := c_line_length;
   g_dt_format   format_mask_t := c_dt_format;
   g_ts_format     format_mask_t := c_ts_format;
   g_null_string   maxvarchar2_t := c_null_string;

   /* Set line length before wrap */
   PROCEDURE set_line_length (length_in IN PLS_INTEGER := c_line_length)
   IS
   BEGIN
      g_line_length := length_in;
   END set_line_length;

   FUNCTION line_length
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_line_length;
   END line_length;

   /* Set format masks. */

   PROCEDURE set_dt_format (format_in IN VARCHAR2)
   IS
   BEGIN
      g_dt_format := format_in;
   END set_dt_format;

   PROCEDURE set_ts_format (format_in IN VARCHAR2)
   IS
   BEGIN
      g_ts_format := format_in;
   END set_ts_format;

   PROCEDURE set_null_string (string_in IN VARCHAR2)
   IS
   BEGIN
      g_null_string := string_in;
   END set_null_string;

   /* Internal display procedure, for VARCHAR2 and CLOB. */

   PROCEDURE display_line (line_in IN VARCHAR2)
   IS
   BEGIN
      IF RTRIM (line_in) IS NULL
      THEN
         DBMS_OUTPUT.put_line (g_null_string);
      ELSIF LENGTH (line_in) > g_line_length
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (line_in, 1, g_line_length));
         display_line (SUBSTR (line_in, g_line_length + 1));
      ELSE
         DBMS_OUTPUT.put_line (line_in);
      END IF;
   END display_line;

   PROCEDURE display_line (line_in IN CLOB)
   IS
   BEGIN
      IF RTRIM (line_in) IS NULL
      THEN
         DBMS_OUTPUT.put_line (g_null_string);
      ELSIF LENGTH (line_in) > g_line_length
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (line_in, 1, g_line_length));
         display_line (SUBSTR (line_in, g_line_length + 1));
      ELSE
         DBMS_OUTPUT.put_line (line_in);
      END IF;
   END display_line;

   /* The overloaded versions of the p.l procedure */

   PROCEDURE l (date_in IN DATE)
   IS
   BEGIN
      display_line (TO_CHAR (date_in, g_dt_format));
   END l;

   PROCEDURE l (timestamp_in IN TIMESTAMP)
   IS
   BEGIN
      display_line (TO_CHAR (timestamp_in, g_ts_format));
   END l;

   PROCEDURE l (number_in IN NUMBER)
   IS
   BEGIN
      display_line (number_in);
   END l;

   PROCEDURE l (string_in IN VARCHAR2)
   IS
   BEGIN
      display_line (string_in);
   END l;

   FUNCTION boolean_to_string (boolean_in IN BOOLEAN)
      RETURN VARCHAR2
   IS
   BEGIN
      IF boolean_in
      THEN
         RETURN 'TRUE';
      ELSIF NOT boolean_in
      THEN
         RETURN 'FALSE';
      ELSE
         RETURN g_null_string;
      END IF;
   END boolean_to_string;

   PROCEDURE l (boolean_in IN BOOLEAN)
   IS
   BEGIN
      l (boolean_to_string (boolean_in));
   END l;

   PROCEDURE l (clob_in IN CLOB)
   IS
      l_lines   DBMS_SQL.varchar2s;

      PROCEDURE clob_to_code_lines (
         clob_in     IN            CLOB
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
         WHILE (l_start <= c_length)
         LOOP
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
   END l;

   PROCEDURE l (xml_in IN SYS.XMLTYPE)
   IS
   BEGIN
      l (xml_in.getclobval ());
   END l;

   /* String first, then another datatype. Useful when you want to show
      a label and then a value. */

   PROCEDURE l (string_in IN VARCHAR2, number_in IN NUMBER)
   IS
   BEGIN
      l (string_in || ' - ' || TO_CHAR (number_in));
   END l;

   PROCEDURE l (string_in IN VARCHAR2, date_in IN DATE)
   IS
   BEGIN
      l (string_in || ' - ' || TO_CHAR (date_in, g_dt_format));
   END l;

   PROCEDURE l (string_in IN VARCHAR2, timestamp_in IN TIMESTAMP)
   IS
   BEGIN
      l (string_in || ' - ' || TO_CHAR (timestamp_in, g_ts_format));
   END l;

   PROCEDURE l (string_in IN VARCHAR2, boolean_in IN BOOLEAN)
   IS
   BEGIN
      l (string_in || ' - ' || boolean_to_string (boolean_in));
   END l;

   /* Two of the same datatype and that's enough! */

   PROCEDURE l (string1_in IN VARCHAR2, string2_in IN VARCHAR2)
   IS
   BEGIN
      l (string1_in || ' - ' || string2_in);
   END l;

   PROCEDURE l (number1_in IN NUMBER, number2_in IN NUMBER)
   IS
   BEGIN
      l (TO_CHAR (number1_in) || ' - ' || TO_CHAR (number2_in));
   END l;

   PROCEDURE l (boolean1_in IN BOOLEAN, boolean2_in IN BOOLEAN)
   IS
   BEGIN
      l(   boolean_to_string (boolean1_in)
        || ' - '
        || boolean_to_string (boolean2_in));
   END l;

   PROCEDURE l (date1_in IN DATE, date2_in IN DATE)
   IS
   BEGIN
      l(   TO_CHAR (date1_in, g_dt_format)
        || ' - '
        || TO_CHAR (date2_in, g_dt_format));
   END l;

   PROCEDURE l (timestamp1_in IN TIMESTAMP, timestamp2_in IN TIMESTAMP)
   IS
   BEGIN
      l(   TO_CHAR (timestamp1_in, g_ts_format)
        || ' - '
        || TO_CHAR (timestamp2_in, g_ts_format));
   END l;
END p;
/