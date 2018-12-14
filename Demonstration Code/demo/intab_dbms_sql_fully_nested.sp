CREATE OR REPLACE PROCEDURE intab (table_in          IN VARCHAR2,
                                   where_in          IN VARCHAR2 DEFAULT NULL,
                                   colname_like_in   IN VARCHAR2 := '%')
   AUTHID CURRENT_USER
IS
   -- Avoid repetitive "maximum size" declarations for VARCHAR2 variables.
   SUBTYPE max_varchar2_t IS VARCHAR2 (32767);

   -- Minimize size of a string column.
   c_min_length   CONSTANT PLS_INTEGER := 10;

   -- Collection to hold the column information for this table.
   TYPE columns_tt IS TABLE OF all_tab_columns%ROWTYPE
      INDEX BY PLS_INTEGER;

   g_columns               columns_tt;
   g_cursor                INTEGER := DBMS_SQL.open_cursor;
   g_query                 max_varchar2_t;
   g_header                max_varchar2_t;
   g_select_list           max_varchar2_t;
   g_row_line_length       INTEGER := 0;

   /* Utility functions that determine the "family" of the column datatype.
      They do NOT comprehensively cover the datatypes supported by Oracle.
     You will need to expand on these programs if you want your version of
     intab to support a wider range of datatypes.
   */
   FUNCTION is_string (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (g_columns (row_in).data_type IN ('CHAR', 'VARCHAR2', 'VARCHAR'));
   END;

   FUNCTION is_number (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (g_columns (row_in).data_type IN ('FLOAT', 'INTEGER', 'NUMBER'));
   END;

   FUNCTION is_date (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (g_columns (row_in).data_type IN ('DATE', 'TIMESTAMP'));
   END;

   PROCEDURE load_column_information
   IS
      l_dot_location   PLS_INTEGER;
      l_owner          VARCHAR2 (100);
      l_table          VARCHAR2 (100);
      l_index          PLS_INTEGER;
      --
      no_such_table    EXCEPTION;
      PRAGMA EXCEPTION_INIT (no_such_table, -942);

      PROCEDURE initialize
      IS
      BEGIN
         -- Separate the schema and table names, if both are present.
         l_dot_location := INSTR (table_in, '.');

         IF l_dot_location > 0
         THEN
            l_owner := SUBSTR (table_in, 1, l_dot_location - 1);
            l_table := SUBSTR (table_in, l_dot_location + 1);
         ELSE
            l_owner := USER;
            l_table := table_in;
         END IF;

         -- Retrieve all the column information into a collection of records.
         SELECT *
           BULK COLLECT INTO g_columns
           FROM all_tab_columns
          WHERE     owner = l_owner
                AND table_name = l_table
                AND column_name LIKE NVL (colname_like_in, '%');

         l_index := g_columns.FIRST;

         IF l_index IS NULL
         THEN
            RAISE no_such_table;
         END IF;
      END;

      FUNCTION data_length (index_in IN INTEGER)
         RETURN INTEGER
      IS
      BEGIN
         RETURN CASE
                   WHEN is_string (l_index)
                   THEN
                      GREATEST (
                         LEAST (g_columns (l_index).data_length,
                                c_min_length),
                         LENGTH (g_columns (l_index).column_name))
                   WHEN is_date (l_index)
                   THEN
                      GREATEST (c_min_length,
                                LENGTH (g_columns (l_index).column_name))
                   WHEN is_number (l_index)
                   THEN
                      GREATEST (NVL (g_columns (l_index).data_precision, 38),
                                LENGTH (g_columns (l_index).column_name))
                END;
      END;
   BEGIN
      initialize;

      WHILE (l_index IS NOT NULL)
      LOOP
         IF g_select_list IS NULL
         THEN
            g_select_list := g_columns (l_index).column_name;
         ELSE
            g_select_list :=
               g_select_list || ', ' || g_columns (l_index).column_name;
         END IF;

         g_columns (l_index).data_length := data_length (l_index);

         g_row_line_length :=
            g_row_line_length + g_columns (l_index).data_length + 1;

         g_header :=
               g_header
            || ' '
            || RPAD (g_columns (l_index).column_name,
                     g_columns (l_index).data_length);
         l_index := g_columns.NEXT (l_index);
      END LOOP;
   END load_column_information;

   PROCEDURE construct_and_parse_query
   IS
      l_where_clause   max_varchar2_t := LTRIM (UPPER (where_in));
   BEGIN
      -- Construct a where clause if a value was specified.
      IF l_where_clause IS NOT NULL
      THEN
         --
         IF (    l_where_clause NOT LIKE 'GROUP BY%'
             AND l_where_clause NOT LIKE 'ORDER BY%')
         THEN
            l_where_clause := 'WHERE ' || LTRIM (l_where_clause, 'WHERE');
         END IF;
      END IF;

      -- Assign the dynamic string to a local variable so that it can be
      -- easily used to report an error.
      g_query :=
            'SELECT '
         || g_select_list
         || '  FROM '
         || table_in
         || ' '
         || l_where_clause;

      DBMS_SQL.parse (g_cursor, g_query, DBMS_SQL.native);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Error parsing query:');
         DBMS_OUTPUT.put_line (g_query);
         RAISE;
   END construct_and_parse_query;

   PROCEDURE define_columns_and_execute
   IS
      l_index      PLS_INTEGER;
      l_feedback   PLS_INTEGER;
   BEGIN
      l_index := g_columns.FIRST;

      WHILE (l_index IS NOT NULL)
      LOOP
         IF is_string (l_index)
         THEN
            DBMS_SQL.define_column (g_cursor,
                                    l_index,
                                    'a',
                                    g_columns (l_index).data_length);
         ELSIF is_number (l_index)
         THEN
            DBMS_SQL.define_column (g_cursor, l_index, 1);
         ELSIF is_date (l_index)
         THEN
            DBMS_SQL.define_column (g_cursor, l_index, SYSDATE);
         END IF;

         l_index := g_columns.NEXT (l_index);
      END LOOP;

      l_feedback := DBMS_SQL.execute (g_cursor);
   END define_columns_and_execute;

   PROCEDURE build_and_display_output
   IS
      -- Used to hold the retrieved column values.
      l_string_value     VARCHAR2 (2000);
      l_number_value     NUMBER;
      l_date_value       DATE;
      --
      l_feedback         INTEGER;
      l_index            PLS_INTEGER;
      l_one_row_string   max_varchar2_t;

      -- Formatting for the output of the header information
      PROCEDURE display_header
      IS
         l_border   max_varchar2_t := RPAD ('-', g_row_line_length, '-');

         FUNCTION centered_string (string_in   IN VARCHAR2,
                                   length_in   IN INTEGER)
            RETURN VARCHAR2
         IS
            len_string   INTEGER := LENGTH (string_in);
         BEGIN
            IF len_string IS NULL OR length_in <= 0
            THEN
               RETURN NULL;
            ELSE
               RETURN    RPAD (' ', (length_in - len_string) / 2 - 1)
                      || LTRIM (RTRIM (string_in));
            END IF;
         END centered_string;
      BEGIN
         DBMS_OUTPUT.put_line (l_border);
         DBMS_OUTPUT.put_line (
            centered_string ('Contents of ' || table_in, g_row_line_length));
         DBMS_OUTPUT.put_line (l_border);
         DBMS_OUTPUT.put_line (g_header);
         DBMS_OUTPUT.put_line (l_border);
      END display_header;
   BEGIN
      display_header;

      -- Fetch one row at a time, until the last has been fetched.
      LOOP
         l_feedback := DBMS_SQL.fetch_rows (g_cursor);
         EXIT WHEN l_feedback = 0;
         --
         l_one_row_string := NULL;
         l_index := g_columns.FIRST;

         WHILE (l_index IS NOT NULL)
         LOOP
            IF is_string (l_index)
            THEN
               DBMS_SQL.COLUMN_VALUE (g_cursor, l_index, l_string_value);
            ELSIF is_number (l_index)
            THEN
               DBMS_SQL.COLUMN_VALUE (g_cursor, l_index, l_number_value);
               l_string_value := TO_CHAR (l_number_value);
            ELSIF is_date (l_index)
            THEN
               DBMS_SQL.COLUMN_VALUE (g_cursor, l_index, l_date_value);
               l_string_value := TO_CHAR (l_date_value);
            END IF;

            l_one_row_string :=
                  l_one_row_string
               || ' '
               || RPAD (NVL (l_string_value, ' '),
                        g_columns (l_index).data_length);
            l_index := g_columns.NEXT (l_index);
         END LOOP;

         DBMS_OUTPUT.put_line (l_one_row_string);
      END LOOP;
   END build_and_display_output;

   PROCEDURE cleanup
   IS
   BEGIN
      IF DBMS_SQL.is_open (g_cursor)
      THEN
         DBMS_SQL.close_cursor (g_cursor);
      END IF;
   END cleanup;
BEGIN
   load_column_information;
   construct_and_parse_query;
   define_columns_and_execute;
   build_and_display_output;
   cleanup;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (
         'Dynamic Query Error: ' || DBMS_UTILITY.format_error_stack);
      /* Note: backtrace is only available in Oracle Database 10g and above. */
      DBMS_OUTPUT.put_line (
         'Error backtrace: ' || DBMS_UTILITY.format_error_backtrace);
      DBMS_OUTPUT.put_line (g_query);
      cleanup;
      RAISE;
END intab;
/