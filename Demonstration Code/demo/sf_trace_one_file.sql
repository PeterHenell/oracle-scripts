/*

SF_TRACE by Steven Feuerstein

Copyright 2013 Feuerstein and Associates

A basic, but flexible trace utility. You can choose to 
send output to a table or to the screen. Trace info
is stored in the sf_trace table. Trace settings are
stored in sf_trace_settings.

This package also includes:

* Encapsulations/improvements for DBMS_OUTPUT.PUT_LINE
* Boolean -> Varchar2 converter
* Utility that generates trace calls for all the IN 
  arguments of your subprogram
  
You are permitted to use this softw
  
*/

CREATE TABLE sf_trace_settings
(
   trace_on           VARCHAR2 (1),
   context_filter     VARCHAR2 (4000),
   trace_target       VARCHAR2 (1),
   callstack_filter   VARCHAR2 (4000)
)
/

CREATE TABLE sf_trace
(
   trace_id     INTEGER,
   context      VARCHAR2 (4000),
   text         CLOB,
   callstack    CLOB,
   created_on   DATE,
   created_by   VARCHAR2 (100)
)
/

CREATE SEQUENCE sf_trace_seq
/

CREATE OR REPLACE PACKAGE sf_trace_pkg
   AUTHID DEFINER
IS
   SUBTYPE maxvarchar2 IS VARCHAR2 (32767);

   TYPE maxvarchar2_aat IS TABLE OF VARCHAR2 (32767)
      INDEX BY PLS_INTEGER;

   c_date_mask   CONSTANT VARCHAR2 (30)
                             := 'YYYY-MM-DD HH24:MI:SS' ;

   /* Where does the trace go? Table is default. */
   c_to_screen   CONSTANT CHAR (1) := 'S';
   c_to_table    CONSTANT CHAR (1) := 'T';

   PROCEDURE clear_trace_entries (
      before_in IN DATE DEFAULT NULL);

   PROCEDURE turn_on_trace (
      context_filter_in       IN VARCHAR2 DEFAULT NULL,
      callstack_contains_in   IN VARCHAR2 DEFAULT NULL,
      send_trace_to_in        IN VARCHAR2 DEFAULT c_to_table);

   PROCEDURE turn_off_trace;

   FUNCTION trace_is_on (
      context_filter_in IN VARCHAR2 DEFAULT NULL)
      RETURN BOOLEAN;

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN VARCHAR2);

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN CLOB);

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN BOOLEAN);

   PROCEDURE trace_activity (
      context_in   IN VARCHAR2,
      data_in      IN DATE,
      format_in    IN VARCHAR2 DEFAULT c_date_mask);

   /* Use this inside expressions and SQL. Always returns 1.*/
   FUNCTION trace_activity (context_in   IN VARCHAR2,
                            data_in      IN VARCHAR2)
      RETURN PLS_INTEGER;

   /* "Force" trace - even if disabled, will write to log */

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN VARCHAR2);

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN CLOB);

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN BOOLEAN);

   PROCEDURE trace_activity_force (
      context_in   IN VARCHAR2,
      data_in      IN DATE,
      format_in    IN VARCHAR2 DEFAULT c_date_mask);

   /* Always returns 1 */
   FUNCTION trace_activity_force (context_in   IN VARCHAR2,
                                  data_in      IN VARCHAR2)
      RETURN PLS_INTEGER;

   /* Substitutes for DBMS_OUTPUT.PUT_LINE */

   FUNCTION bool2vc (bool IN BOOLEAN)
      RETURN VARCHAR2;

   PROCEDURE put_line (data_in IN VARCHAR2);

   PROCEDURE put_line (data_in IN BOOLEAN);

   PROCEDURE put_line (
      data_in     IN DATE,
      format_in   IN VARCHAR2 DEFAULT c_date_mask);

   PROCEDURE put_line (
      clob_in            IN CLOB,
      append_in          IN BOOLEAN DEFAULT TRUE,
      preserve_code_in   IN BOOLEAN DEFAULT FALSE);

   /* Generate tracing of IN parameters for subprogram */
   PROCEDURE gen_trace_call (
      pkg_or_prog_in               VARCHAR2,
      pkg_subprog_in               VARCHAR2 DEFAULT NULL,
      tracing_enabled_func_in   IN VARCHAR2 DEFAULT 'sf_trace_pkg.trace_is_on',
      trace_func_in             IN VARCHAR2 DEFAULT 'sf_trace_pkg.trace_activity');
END sf_trace_pkg;
/

CREATE OR REPLACE PACKAGE BODY sf_trace_pkg
IS
   TYPE trace_rt IS RECORD
   (
      tracing         BOOLEAN DEFAULT FALSE,
      trace_context   maxvarchar2,
      callstack       maxvarchar2,
      trace_target    maxvarchar2
   );

   g_trace   trace_rt;

   FUNCTION bool2vc (bool IN BOOLEAN)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE
                WHEN bool THEN 'TRUE'
                WHEN NOT bool THEN 'FALSE'
                ELSE 'NULL'
             END;
   END;

   PROCEDURE turn_on_trace (
      context_filter_in       IN VARCHAR2 DEFAULT NULL,
      callstack_contains_in   IN VARCHAR2 DEFAULT NULL,
      send_trace_to_in        IN VARCHAR2 DEFAULT c_to_table)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* Also set global flag, so that multiple calls in the same
        server call can use this and not select from the table. */
      g_trace.tracing := TRUE;
      g_trace.trace_context :=
         '%' || UPPER (context_filter_in) || '%';
      g_trace.callstack := UPPER (callstack_contains_in);
      g_trace.trace_target := send_trace_to_in;

      /* And set the table too */
      UPDATE sf_trace_settings
         SET trace_on = 'Y',
             context_filter =
                CASE
                   WHEN context_filter_in IS NULL THEN '%'
                   ELSE g_trace.trace_context
                END,
             callstack_filter = g_trace.callstack,
             trace_target = send_trace_to_in;

      COMMIT;
   END;

   PROCEDURE turn_off_trace
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE sf_trace_settings
         SET trace_on = 'N', context_filter = '%';

      COMMIT;
   END;

   FUNCTION trace_is_on (
      context_filter_in IN VARCHAR2 DEFAULT NULL)
      RETURN BOOLEAN
   IS
      l_trace_settings   sf_trace_settings%ROWTYPE;
      l_trace            CHAR (1);
      l_filter           VARCHAR2 (100);
      l_return           BOOLEAN DEFAULT FALSE;
   BEGIN
      /* If this flag is set, then we are done (avoid SELECT). */
      IF g_trace.tracing
      THEN
         l_return :=
               context_filter_in IS NULL
            OR UPPER (context_filter_in) LIKE
                  g_trace.trace_context;
      ELSE
         SELECT * INTO l_trace_settings FROM sf_trace_settings;

         l_return := l_trace_settings.trace_on = 'Y';

         IF l_return AND context_filter_in IS NOT NULL
         THEN
            l_return :=
               UPPER (context_filter_in) LIKE
                  l_trace_settings.context_filter;
         END IF;
      END IF;

      RETURN l_return;
   END trace_is_on;

   PROCEDURE internal_trace (context_in    IN VARCHAR2,
                             data_in       IN VARCHAR2,
                             override_in   IN BOOLEAN)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      c_callstack   CONSTANT maxvarchar2
         := DBMS_UTILITY.format_call_stack ;
      l_trace_settings       sf_trace_settings%ROWTYPE;

      l_trace_it             BOOLEAN
         := override_in OR trace_is_on (context_in);

      c_context     CONSTANT sf_trace.text%TYPE
                                := SUBSTR (context_in, 1, 4000) ;
   BEGIN
      IF l_trace_it
      THEN
         SELECT * INTO l_trace_settings FROM sf_trace_settings;

         IF l_trace_settings.callstack_filter IS NOT NULL
         THEN
            l_trace_it :=
               INSTR (c_callstack,
                      l_trace_settings.callstack_filter) > 0;
         END IF;
      END IF;

      IF l_trace_it
      THEN
         CASE l_trace_settings.trace_target
            WHEN c_to_screen
            THEN
               put_line (context_in || ': ' || data_in);
            ELSE
               INSERT INTO sf_trace (trace_id,
                                     context,
                                     text,
                                     callstack)
                    VALUES (sf_trace_seq.NEXTVAL,
                            c_context,
                            data_in,
                            c_callstack);

               COMMIT;
         END CASE;
      END IF;
   END;

   PROCEDURE internal_trace (context_in    IN VARCHAR2,
                             data_in       IN CLOB,
                             override_in   IN BOOLEAN)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_trace_settings     sf_trace_settings%ROWTYPE;
      l_trace_it           BOOLEAN
         := override_in OR trace_is_on (context_in);
      c_context   CONSTANT sf_trace.text%TYPE
                              := SUBSTR (context_in, 1, 4000) ;
   BEGIN
      SELECT * INTO l_trace_settings FROM sf_trace_settings;

      IF     NOT l_trace_it
         AND l_trace_settings.callstack_filter IS NOT NULL
      THEN
         l_trace_it :=
            INSTR (DBMS_UTILITY.format_call_stack,
                   l_trace_settings.callstack_filter) > 0;
      END IF;

      IF l_trace_it
      THEN
         CASE l_trace_settings.trace_target
            WHEN c_to_screen
            THEN
               put_line (context_in || ': ' || data_in);
            ELSE
               INSERT INTO sf_trace (context, text, callstack)
                    VALUES (
                              c_context,
                              data_in,
                              DBMS_UTILITY.format_call_stack);

               COMMIT;
         END CASE;
      END IF;
   END;

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN VARCHAR2)
   IS
   BEGIN
      internal_trace (context_in, data_in, override_in => FALSE);
   END;

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN CLOB)
   IS
   BEGIN
      internal_trace (context_in, data_in, override_in => FALSE);
   END;

   PROCEDURE trace_activity (context_in   IN VARCHAR2,
                             data_in      IN BOOLEAN)
   IS
   BEGIN
      internal_trace (context_in,
                      bool2vc (data_in),
                      override_in   => FALSE);
   END;

   PROCEDURE trace_activity (
      context_in   IN VARCHAR2,
      data_in      IN DATE,
      format_in    IN VARCHAR2 DEFAULT c_date_mask)
   IS
   BEGIN
      internal_trace (context_in,
                      TO_CHAR (data_in, format_in),
                      override_in   => FALSE);
   END;

   /* Use this inside expressions and SQL */

   FUNCTION trace_activity (context_in   IN VARCHAR2,
                            data_in      IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      trace_activity (context_in, data_in);
      RETURN 1;
   END;

   FUNCTION trace_activity_force (context_in   IN VARCHAR2,
                                  data_in      IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      trace_activity_force (context_in, data_in);
      RETURN 1;
   END;

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN VARCHAR2)
   IS
   BEGIN
      internal_trace (context_in, data_in, override_in => TRUE);
   END;

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN CLOB)
   IS
   BEGIN
      internal_trace (context_in, data_in, override_in => TRUE);
   END;

   PROCEDURE trace_activity_force (context_in   IN VARCHAR2,
                                   data_in      IN BOOLEAN)
   IS
   BEGIN
      internal_trace (context_in,
                      bool2vc (data_in),
                      override_in   => TRUE);
   END;

   PROCEDURE trace_activity_force (
      context_in   IN VARCHAR2,
      data_in      IN DATE,
      format_in    IN VARCHAR2 DEFAULT c_date_mask)
   IS
   BEGIN
      internal_trace (context_in,
                      TO_CHAR (data_in, format_in),
                      override_in   => TRUE);
   END;

   PROCEDURE clear_trace_entries (
      before_in IN DATE DEFAULT NULL)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      DELETE FROM sf_trace
            WHERE created_on <= NVL (before_in, SYSDATE);

      COMMIT;
   END;

   /* End Trace Functionality */

   /* Substitutes for DBMS_OUTPUT.PUT_LINE */

   PROCEDURE put_line (data_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (data_in);
   END;

   PROCEDURE put_line (
      data_in     IN DATE,
      format_in   IN VARCHAR2 DEFAULT c_date_mask)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (TO_CHAR (data_in, format_in));
   END;

   PROCEDURE put_line (data_in IN BOOLEAN)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (bool2vc (data_in));
   END;

   PROCEDURE put_line (title_in IN VARCHAR2, data_in IN BOOLEAN)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         title_in || ' - ' || bool2vc (data_in));
   END;

   PROCEDURE put_line (
      clob_in            IN CLOB,
      append_in          IN BOOLEAN DEFAULT TRUE,
      preserve_code_in   IN BOOLEAN DEFAULT FALSE)
   IS
      l_lines   DBMS_SQL.varchar2s;

      PROCEDURE clob_to_code_lines (
         clob_in       IN            CLOB,
         lines_inout   IN OUT NOCOPY DBMS_SQL.varchar2s)
      IS
         c_array_max         CONSTANT PLS_INTEGER DEFAULT 250;
         c_delim_not_found   CONSTANT PLS_INTEGER
                                         DEFAULT 99999999 ;
         c_length            CONSTANT PLS_INTEGER
                                         := LENGTH (clob_in) ;
         l_string                     VARCHAR2 (255);
         l_start                      PLS_INTEGER := 1;
         l_latest_delim               PLS_INTEGER;

         TYPE delims_t IS TABLE OF VARCHAR2 (1);

         l_delims                     delims_t
            := delims_t (' ', ';', CHR (10));

         FUNCTION latest_delim (string_in   IN CLOB,
                                start_in    IN PLS_INTEGER)
            RETURN PLS_INTEGER
         IS
            l_string      VARCHAR2 (32767)
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
                  l_delim_loc :=
                     INSTR (l_string,
                            l_delims (indx),
                            -1,
                            1);

                  IF l_delim_loc > 0
                  THEN
                     l_location :=
                        LEAST (l_location, l_delim_loc);
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
                        -20000,
                        'Unable to parse a CLOB without delimiters - string block too long.');
                  ELSE
                     l_string :=
                        SUBSTR (clob_in,
                                l_start,
                                c_array_max + l_start - 1);
                     l_start := l_start + c_array_max;
                  END IF;
               ELSIF l_latest_delim > 0
               THEN
                  l_string :=
                     SUBSTR (clob_in,
                             l_start,
                             l_latest_delim - l_start + 1);
                  l_start := l_latest_delim + 1;
               ELSE
                  l_string :=
                     SUBSTR (clob_in,
                             l_start,
                             c_array_max + l_start - 1);
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
   END put_line;

   PROCEDURE initialize
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_count   PLS_INTEGER;
   BEGIN
      /* Make sure there is a row */

      SELECT COUNT (*) INTO l_count FROM sf_trace_settings;

      IF l_count = 0
      THEN
         INSERT INTO sf_trace_settings (trace_on,
                                        context_filter,
                                        trace_target,
                                        callstack_filter)
              VALUES ('N',
                      NULL,
                      c_to_table,
                      NULL);

         COMMIT;
      END IF;
   END;

   PROCEDURE gen_trace_call (
      pkg_or_prog_in               VARCHAR2,
      pkg_subprog_in               VARCHAR2 DEFAULT NULL,
      tracing_enabled_func_in   IN VARCHAR2 DEFAULT 'sf_trace_pkg.trace_is_on',
      trace_func_in             IN VARCHAR2 DEFAULT 'sf_trace_pkg.trace_activity')
   IS
      CURSOR arg_info_cur (
         prog_in      IN VARCHAR2,
         subprog_in   IN VARCHAR2 DEFAULT NULL)
      IS
           SELECT NVL (argument_name, 'RETURN_VALUE')
                     argument_name,
                  data_type,
                  in_out
             FROM user_arguments
            WHERE     (   (    package_name = prog_in
                           AND subprog_in IS NULL)
                       OR (    package_name IS NULL
                           AND object_name = prog_in)
                       OR (    package_name = prog_in
                           AND object_name = subprog_in))
                  AND data_level = 0
         ORDER BY position;

      TYPE arg_info_aat IS TABLE OF arg_info_cur%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_in_args    arg_info_aat;
      l_out_args   arg_info_aat;

      PROCEDURE get_argument_info (
         in_args    IN OUT arg_info_aat,
         out_args   IN OUT arg_info_aat)
      IS
         l_arg_info   arg_info_aat;
      BEGIN
         OPEN arg_info_cur (pkg_or_prog_in, pkg_subprog_in);

         FETCH arg_info_cur
         BULK COLLECT INTO l_arg_info;

         FOR indx IN 1 .. l_arg_info.COUNT
         LOOP
            IF l_arg_info (indx).in_out IN ('IN', 'IN/OUT')
            THEN
               in_args (in_args.COUNT + 1) := l_arg_info (indx);
            END IF;

            IF l_arg_info (indx).in_out IN ('OUT', 'IN/OUT')
            THEN
               out_args (out_args.COUNT + 1) := l_arg_info (indx);
            END IF;
         END LOOP;
      END get_argument_info;

      FUNCTION trace_prog_name (arg_type_in IN VARCHAR2)
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN 'trace_' || arg_type_in || '_arguments';
      END trace_prog_name;

      PROCEDURE gen_trace_proc (arg_type_in   IN VARCHAR2,
                                args_in          arg_info_aat,
                                comment_in    IN VARCHAR2)
      IS
         FUNCTION bool_to_char_function (
            arg_type_in IN VARCHAR2)
            RETURN VARCHAR2
         IS
            l_have_boolean   BOOLEAN DEFAULT FALSE;
         BEGIN
            /* If there is one or more boolean argument, then add
               the to_char converter function and use it. */
            FOR indx IN 1 .. args_in.COUNT
            LOOP
               IF args_in (indx).data_type IN
                     ('BOOLEAN', 'PL/SQL BOOLEAN')
               THEN
                  l_have_boolean := TRUE;
               END IF;
            END LOOP;

            IF l_have_boolean
            THEN
               RETURN    'FUNCTION bool_to_char (bool_in in boolean) RETURN VARCHAR2 IS BEGIN '
                      || CHR (10)
                      || 'IF bool_in THEN RETURN ''TRUE''; '
                      || CHR (10)
                      || 'ELSIF NOT bool_in THEN RETURN ''FALSE''; '
                      || CHR (10)
                      || 'ELSE RETURN ''NULL''; END IF; END bool_to_char;';
            ELSE
               RETURN NULL;
            END IF;
         END bool_to_char_function;

         FUNCTION converted (index_in      IN PLS_INTEGER,
                             arg_name_in   IN VARCHAR2)
            RETURN VARCHAR2
         IS
         BEGIN
            IF args_in (index_in).data_type IN
                  ('BOOLEAN', 'PL/SQL BOOLEAN')
            THEN
               RETURN 'bool_to_char (' || arg_name_in || ')';
            ELSE
               RETURN arg_name_in;
            END IF;
         END converted;
      BEGIN
         IF args_in.COUNT > 0
         THEN
            DBMS_OUTPUT.put_line ('');
            DBMS_OUTPUT.put_line ('   ' || comment_in);
            DBMS_OUTPUT.put_line (
                  'PROCEDURE '
               || trace_prog_name (arg_type_in)
               || ' IS '
               || bool_to_char_function (arg_type_in)
               || ' BEGIN '
               || CHR (10)
               || '   IF '
               || tracing_enabled_func_in
               || ' THEN '
               || CHR (10)
               || '      '
               || trace_func_in
               || ' ('''
               || pkg_or_prog_in
               || CASE
                     WHEN pkg_subprog_in IS NULL THEN NULL
                     ELSE '.' || pkg_subprog_in
                  END
               || ''', ');

            FOR indx IN 1 .. args_in.COUNT
            LOOP
               DBMS_OUTPUT.put_line (
                     CASE
                        WHEN indx = 1 THEN ''''
                        ELSE '|| '' - '
                     END
                  || args_in (indx).argument_name
                  || '='' || '
                  || converted (indx,
                                args_in (indx).argument_name)
                  || CHR (10)
                  || '      ');
            END LOOP;

            DBMS_OUTPUT.put_line (
                  '      );'
               || CHR (10)
               || '   END IF;'
               || CHR (10)
               || 'END '
               || trace_prog_name (arg_type_in)
               || ';');
         END IF;
      END gen_trace_proc;
   BEGIN
      get_argument_info (l_in_args, l_out_args);
      /* Place procedures in anonymous block for easy formatting. */
      DBMS_OUTPUT.put_line ('DECLARE');
      gen_trace_proc (
         'IN',
         l_in_args,
         '/* AFTER ENTERING - IN and IN OUT argument tracing */');
      gen_trace_proc (
         'OUT',
         l_out_args,
         '/* BEFORE LEAVING - OUT and IN OUT argument tracing */');
      /* Place procedures in anonymous block for easy formatting. */
      DBMS_OUTPUT.put_line ('BEGIN');
      DBMS_OUTPUT.put_line (trace_prog_name ('IN') || '();');
      DBMS_OUTPUT.put_line ('/*');
      DBMS_OUTPUT.put_line ('   Your Code Here!');
      DBMS_OUTPUT.put_line ('*/');
      DBMS_OUTPUT.put_line (trace_prog_name ('OUT') || '();');
      DBMS_OUTPUT.put_line ('END;');
   END gen_trace_call;
BEGIN
   initialize;
END sf_trace_pkg;
/

/*

Demonstration script 

*/

CREATE OR REPLACE FUNCTION betwnstr (string_in   IN VARCHAR2,
                                     start_in    IN INTEGER,
                                     end_in      IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   /* Check to see if trace is turned on before calling
      the trace procedure, to minimize runtime overhead
      when tracing is disabled. */

   IF sf_trace_pkg.trace_is_on
   THEN
      sf_trace_pkg.trace_activity ('betwnstr string', string_in);
   END IF;

   sf_trace_pkg.trace_activity_force ('betwnstr start-end',
                                      start_in || '-' || end_in);

   RETURN (SUBSTR (string_in, start_in, end_in - start_in + 1));
END betwnstr;
/

BEGIN
   sf_trace_pkg.turn_on_trace;
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_on_trace (context_filter_in => 'xyz');
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_off_trace;
END;
/

  SELECT context || '-' || text
    FROM sf_trace
ORDER BY created_on
/

DELETE FROM sf_trace
/

COMMIT
/

/* Now write to screen */

BEGIN
   sf_trace_pkg.turn_on_trace (
      context_filter_in   => 'betwnstr',
      send_trace_to_in    => sf_trace_pkg.c_to_screen);
   sf_trace_pkg.put_line (betwnstr ('abcdefg', 3, 5));
   sf_trace_pkg.turn_off_trace;
END;
/

/* Demonstrate replacement for dbms_output.put_line */

BEGIN
   sf_trace_pkg.put_line ('abc');
   sf_trace_pkg.put_line (SYSDATE);
   sf_trace_pkg.put_line (TRUE);
END;
/

/* Generate trace of IN arguments */

BEGIN
   sf_trace_pkg.gen_trace_call ('BETWNSTR');
END;
/

/* If you want to remove the sf_trace utility:

DROP TABLE sf_trace_settings
/

DROP TABLE sf_trace
/

DROP SEQUENCE sf_trace_seq
/

DROP PACKAGE sf_trace_pkg
/

*/