Step 1 Move complex logic into separate, perhaps local, modules. (PL/SQL refactoring)

With such a large, complex program, you are probably best off starting from "sc
cratch" in terms of the main or top-level executable section. That way you don'
't get overwhelmed by all of the details.

Universal ID = {53FD10DF-A4ED-4F1F-AEF6-4607ADB121CC}

BEGIN
   retrieve_column_information (table_in, line_length);
   display_header (line_length);
   generate_data;
END intab;
================================================================================
Step 2 Move complex logic into separate, perhaps local, modules. (PL/SQL refactoring)

Now start with the first local module in the executable section and elaborate t
that one. Where necessary create other local modules to keep your executable se
ection small and understandable. As you move through this process iteratively, 
 your code will remain transparent.

Note: this step contains the currently "finished" version of this program. Ther
re is still a lot more work that could be done on it, but it is much clearer th
han the original.

Universal ID = {15A2C3FD-3308-446F-A8F6-C40EF626F64A}

CREATE OR REPLACE PROCEDURE Intab (
   table_in            IN   VARCHAR2
  ,string_length_in    IN   INTEGER := 20
  ,where_in            IN   VARCHAR2 := NULL
  ,date_format_in      IN   VARCHAR2 := 'MM/DD/YY HHMISS'
  ,collike_filter_in   IN   VARCHAR2 := '%'
  ,colin_filter_in     IN   VARCHAR2 := NULL
)
-- Kista 3/2004
AUTHID CURRENT_USER
IS
   -- Use the cursor to establish the collection of records.
   -- A different cursor will be used for the bulk fetch,
   -- because an explicit cursor is not yet allowed (9iR2).
   CURSOR col_cur (owner_in IN VARCHAR2, table_in IN VARCHAR2)
   IS
      SELECT column_name
            ,data_type
            ,data_length
            ,data_precision
            ,data_scale
            ,1 column_width
        -- placeholder for column width
      FROM   ALL_TAB_COLUMNS
       WHERE owner = owner_in AND table_name = table_in;
 
   TYPE col_tt IS TABLE OF col_cur%ROWTYPE
      INDEX BY BINARY_INTEGER;
 
   l_columns          col_tt;
   line_length        PLS_INTEGER := 0;
   no_columns_found   EXCEPTION;
 
   -- Generic utilities
   PROCEDURE Pl (
      str         IN   VARCHAR2
     ,len         IN   INTEGER := 255
     ,expand_in   IN   BOOLEAN := TRUE
   )
   IS
      v_len   PLS_INTEGER     := LEAST (len, 255);
      v_str   VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         Pl (SUBSTR (str, len + 1), v_len, expand_in);
      ELSE
         v_str := str;
         DBMS_OUTPUT.put_line (v_str);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF expand_in
         THEN
            DBMS_OUTPUT.ENABLE (1000000);
            DBMS_OUTPUT.put_line (v_str);
         ELSE
            RAISE;
         END IF;
   END;
 
   FUNCTION Ifelse (
      condition_in   IN   BOOLEAN
     ,iftrue         IN   VARCHAR2
     ,iffalse        IN   VARCHAR2
     ,ifnull         IN   VARCHAR2 := NULL
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF condition_in
      THEN
         RETURN iftrue;
      ELSIF NOT condition_in
      THEN
         RETURN iffalse;
      ELSE
         RETURN ifnull;
      END IF;
   END;
 
   -- end generic utilities
   FUNCTION is_string (colrec_in IN col_cur%ROWTYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (colrec_in.data_type IN ('CHAR', 'VARCHAR2'));
   END;
 
   FUNCTION is_number (colrec_in IN col_cur%ROWTYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (colrec_in.data_type IN ('FLOAT', 'INTEGER', 'NUMBER'));
   END;
 
   FUNCTION is_date (colrec_in IN col_cur%ROWTYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (colrec_in.data_type = 'DATE');
   END;
 
   FUNCTION centered_string (string_in IN VARCHAR2, length_in IN INTEGER)
      RETURN VARCHAR2
   IS
      len_string   INTEGER := LENGTH (string_in);
   BEGIN
      IF len_string IS NULL OR length_in <= 0
      THEN
         RETURN NULL;
      ELSE
         RETURN    RPAD ('_', (length_in - len_string) / 2 - 1)
                || LTRIM (RTRIM (string_in));
      END IF;
   END;
 
   FUNCTION datalength (colrec_in IN col_cur%ROWTYPE)
      RETURN PLS_INTEGER
   IS
      retval   PLS_INTEGER;
   BEGIN
      IF is_string (colrec_in)
      THEN
         retval :=
            GREATEST (LEAST (colrec_in.data_length, string_length_in)
                     ,LENGTH (colrec_in.column_name)
                     );
      ELSIF is_date (colrec_in)
      THEN
         retval :=
            GREATEST (LENGTH (date_format_in)
                     ,LENGTH (colrec_in.column_name));
      ELSIF is_number (colrec_in)
      THEN
         retval :=
            GREATEST (NVL (colrec_in.data_precision, 38)
                     ,LENGTH (colrec_in.column_name)
                     );
      END IF;
 
      RETURN retval;
   END datalength;
 
   PROCEDURE retrieve_column_information (
      table_in     IN       VARCHAR2
     ,length_out   OUT      PLS_INTEGER
   )
   IS
      owner_nm   VARCHAR2 (100)  := USER;
      table_nm   VARCHAR2 (100)  := UPPER (table_in);
      dot_loc    PLS_INTEGER;
      l_filter   VARCHAR2 (500)  := NULL;
      l_query    VARCHAR2 (1000);
 
      PROCEDURE create_col_filter
      IS
      BEGIN
         IF collike_filter_in = '%' AND colin_filter_in IS NULL
         THEN
            l_filter := NULL;
         ELSE
            l_filter :=
                      'AND (column_name like ''' || collike_filter_in || '''';
 
            IF colin_filter_in IS NOT NULL
            THEN
               l_filter :=
                     l_filter
                  || 'and column_name in ('''
                  || REPLACE (UPPER (colin_filter_in), ',', ''',''')
                  || ''')';
            END IF;
 
            l_filter := l_filter || ')';
         END IF;
      END;
   BEGIN
      dot_loc := INSTR (table_nm, '.');
 
      IF dot_loc > 0
      THEN
         owner_nm := SUBSTR (table_nm, 1, dot_loc - 1);
         table_nm := SUBSTR (table_nm, dot_loc + 1);
      END IF;
 
      create_col_filter;
 
      l_query :=
            'SELECT column_name
            ,data_type
            ,data_length
            ,data_precision
            ,data_scale
            ,1 column_width -- placeholder for column width      
        FROM ALL_TAB_COLUMNS
       WHERE owner = :owner_nm AND table_name = :table_nm '
         || l_filter;
 
      EXECUTE IMMEDIATE l_query
      BULK COLLECT INTO l_columns
                  USING owner_nm, table_nm;
 
      IF l_columns.COUNT = 0
      THEN
         RAISE no_columns_found;
      END IF;
 
      length_out := 0;
 
      FOR indx IN l_columns.FIRST .. l_columns.LAST
      LOOP
         l_columns (indx).column_width := datalength (l_columns (indx));
         length_out := length_out + l_columns (indx).column_width + 1;
      END LOOP;
   EXCEPTION
      WHEN no_columns_found
      THEN
         Pl ('No columns found for the following query:');
         Pl (l_query);
         RAISE;
      WHEN OTHERS
      THEN
         Pl ('intab/retrieve column info error: ');
         Pl (SQLERRM);
         Pl ('for the following query:');
         Pl (l_query);
         RAISE;
   END retrieve_column_information;
 
   PROCEDURE display_header (length_in IN PLS_INTEGER)
   IS
      col_border   VARCHAR2 (2000);
      col_header   VARCHAR2 (2000);
   BEGIN
      FOR indx IN l_columns.FIRST .. l_columns.LAST
      LOOP
         col_header :=
               col_header
            || Ifelse (indx = l_columns.FIRST, NULL, ' ')
            || RPAD (l_columns (indx).column_name
                    ,l_columns (indx).column_width
                    );
      END LOOP;
 
      col_border := RPAD ('-', length_in, '-');
      Pl (col_border);
      Pl (centered_string ('Contents of ' || table_in, length_in));
      Pl (col_border);
      Pl (col_header);
      Pl (col_border);
   END;
 
   PROCEDURE generate_data
   IS
      l_block    VARCHAR2 (32767);
      col_list   VARCHAR2 (2000);
 
      FUNCTION query_string
         RETURN VARCHAR2
      IS
         FUNCTION where_clause
            RETURN VARCHAR2
         IS
            retval   VARCHAR2 (1000) := LTRIM (UPPER (where_in));
         BEGIN
            IF retval IS NOT NULL
            THEN
               IF (retval NOT LIKE 'GROUP BY%' AND retval NOT LIKE 'ORDER BY%'
                  )
               THEN
                  retval := 'WHERE ' || LTRIM (where_clause, 'WHERE');
               END IF;
            END IF;
 
            RETURN retval;
         END;
      BEGIN
         FOR indx IN l_columns.FIRST .. l_columns.LAST
         LOOP
            col_list :=
                  col_list
               || l_columns (indx).column_name
               || ' col'
               || indx
               || Ifelse (indx = l_columns.LAST, NULL, ',');
         END LOOP;
 
         RETURN    'SELECT '
                || col_list
                || '  FROM '
                || table_in
                || ' '
                || where_clause;
      END query_string;
 
      FUNCTION concatenated_values
         RETURN VARCHAR2
      IS
         retval   VARCHAR2 (32767);
 
         FUNCTION one_value (value_in IN VARCHAR2, length_in IN PLS_INTEGER)
            RETURN VARCHAR2
         IS
         BEGIN
            RETURN 'RPAD (NVL (' || value_in || ', '' ''), ' || length_in
                   || ')';
         END;
      BEGIN
         FOR col_ind IN l_columns.FIRST .. l_columns.LAST
         LOOP
            retval :=
                  retval
               || Ifelse (col_ind = l_columns.FIRST, NULL, '|| '' '' || ')
               || CASE
                     WHEN is_string (l_columns (col_ind))
                        THEN one_value ('rec.col' || col_ind
                                       ,l_columns (col_ind).column_width
                                       )
                     WHEN is_number (l_columns (col_ind))
                        THEN one_value ('TO_CHAR (rec.col' || col_ind || ')'
                                       ,l_columns (col_ind).column_width
                                       )
                     WHEN is_date (l_columns (col_ind))
                        THEN one_value (   'TO_CHAR (rec.col'
                                        || col_ind
                                        || ', '''
                                        || date_format_in
                                        || ''')'
                                       ,l_columns (col_ind).column_width
                                       )
                  END;
         END LOOP;
 
         RETURN retval;
      END concatenated_values;
   BEGIN
      -- 7/2003 Ostermundigen
      -- Add pl to the dynamic block to avoid an
      -- external dependency.
      l_block :=
            'DECLARE 
               PROCEDURE Pl (
                str IN VARCHAR2,
                len IN INTEGER := 255,
                expand_in IN BOOLEAN := TRUE
             )
             IS
                v_len PLS_INTEGER := LEAST (len, 255);
                v_str VARCHAR2 (2000);
             BEGIN
                IF LENGTH (str) > v_len
                THEN
                   v_str := SUBSTR (str, 1, v_len);
                   DBMS_OUTPUT.put_line (v_str);
                   Pl (SUBSTR (str, len + 1),
                       v_len,
                       expand_in
                      );
                ELSE
                   v_str := str;
                   DBMS_OUTPUT.put_line (v_str);
                END IF;
             EXCEPTION
                WHEN OTHERS
                THEN
                   IF expand_in
                   THEN
                      DBMS_OUTPUT.ENABLE (1000000);
                      DBMS_OUTPUT.put_line (v_str);
                   ELSE
                      RAISE;
                   END IF;
             END;' || 
            'BEGIN
                FOR rec IN ('  || query_string || ')
                LOOP
                   Pl (' || concatenated_values || ');
                END LOOP;
             END;';
 
      EXECUTE IMMEDIATE l_block;
   EXCEPTION
      WHEN OTHERS
      THEN
         Pl ('intab/data retrieval error: ');
         Pl (SQLERRM);
         Pl ('for the following block:');
         Pl (l_block);
   END;
/* MAIN intab */
BEGIN
   retrieve_column_information (table_in, line_length);
   display_header (line_length);
   generate_data;
EXCEPTION
   WHEN no_columns_found
   THEN
      Pl ('Sorry, no table/columns found for specified query...');
END;
/
================================================================================
Step 0: Problematic code for  Move complex logic into separate, perhaps local, modules. (PL/SQL refactoring) 

The problematic code for that demonstrates "Move complex logic into separate, p
perhaps local, modules. (PL/SQL refactoring)"

This program (intab) performs a "SELECT * FROM <table>" inside PL/SQL. It relie
es on and is a good demonstration of method 4 dynamic SQL using DBMS_SQL.

Unfortunately, it is also a large complex program that is composed 

Universal ID = {822C34BF-A32F-410A-864E-656420BF7001}

CREATE OR REPLACE PROCEDURE intab (
   table_in IN VARCHAR2,
   string_length_in IN INTEGER := 20,
   where_in IN VARCHAR2 := NULL,
   date_format_in IN VARCHAR2 := 'MM/DD/YY HHMISS'
   )
IS
   CURSOR col_cur (
      owner_in IN VARCHAR2,
      table_in IN VARCHAR2
      )
   IS
      SELECT column_name,
             data_type,
             data_length,
             data_precision,
             data_scale
        FROM all_tab_columns
       WHERE owner = owner_in
         AND table_name = table_in;
   
   TYPE string_tab IS TABLE OF VARCHAR2(100)
      INDEX BY BINARY_INTEGER;
   
   TYPE integer_tab IS TABLE OF PLS_INTEGER
      INDEX BY BINARY_INTEGER;
   
   colname                       string_tab;
   coltype                       string_tab;
   collen                        integer_tab;
   
   owner_nm                      VARCHAR2(100) := USER;
   table_nm                      VARCHAR2(100)
      := UPPER (table_in);
   where_clause                  VARCHAR2(1000)
      := LTRIM (UPPER (where_in));
   
   cur                           INTEGER
      := DBMS_SQL.open_cursor;
   fdbk                          INTEGER := 0;
   
   string_value                  VARCHAR2(2000);
   number_value                  NUMBER;
   date_value                    DATE;
   
   dot_loc                       INTEGER;
   
   col_count                     INTEGER := 0;
   col_border                    VARCHAR2(2000);
   col_header                    VARCHAR2(2000);
   col_line                      VARCHAR2(2000);
   col_list                      VARCHAR2(2000);
   
   line_length                   INTEGER := 0;
   v_length                      INTEGER;
   
   FUNCTION is_string (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN  (coltype (row_in) IN ('CHAR', 'VARCHAR2'));
   END;
   
   FUNCTION is_number (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN  (
         coltype (row_in) IN ('FLOAT', 'INTEGER', 'NUMBER'));
   END;
   
   FUNCTION is_date (row_in IN INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN  (coltype (row_in) = 'DATE');
   END;
   
   FUNCTION centered_string (
      string_in IN VARCHAR2,
      length_in IN INTEGER
      )
      RETURN VARCHAR2
   IS
      len_string                    INTEGER
         := LENGTH (string_in);
   BEGIN
      IF    len_string IS NULL
         OR length_in <= 0
      THEN
         RETURN NULL;
      ELSE
         RETURN RPAD ('_',
                 (length_in - len_string) / 2 - 1
                ) ||
                LTRIM (RTRIM (string_in));
      END IF;
   END;
 
BEGIN
   dot_loc := INSTR (table_nm, '.');
   IF dot_loc > 0
   THEN
      owner_nm := SUBSTR (table_nm, 1, dot_loc - 1);
      table_nm := SUBSTR (table_nm, dot_loc + 1);
   END IF;
   
   FOR col_rec IN col_cur (owner_nm, table_nm)
   LOOP
      col_list := col_list || ', ' || col_rec.column_name;
      
      /* Save datatype and length for define column calls. */
 
      
      col_count := col_count + 1;
      colname  (col_count) := col_rec.column_name;
      coltype  (col_count) := col_rec.data_type;
      
      IF is_string (col_count)
      THEN
         v_length :=
            GREATEST (LEAST (
                         col_rec.data_length,
                         string_length_in
                      ),
            LENGTH (col_rec.column_name)
            );
      
      ELSIF is_date (col_count)
      THEN
         v_length :=
            GREATEST (LENGTH (date_format_in),
            LENGTH (col_rec.column_name)
            );
      
      ELSIF is_number (col_count)
      THEN
         v_length :=
            GREATEST (NVL (col_rec.data_precision, 38),
            LENGTH (col_rec.column_name)
            );
      END IF;
      
      collen  (col_count) := v_length;
      line_length := line_length + v_length + 1;
      
      /* Construct column header line. */
 
      
      col_header :=
         col_header ||
         ' ' ||
         RPAD (col_rec.column_name, v_length);
   END LOOP;
   
   col_list := RTRIM (LTRIM (col_list, ', '), ', ');
   col_header := LTRIM (col_header);
   col_border := RPAD ('-', line_length, '-');
   
   IF where_clause IS NOT NULL
   THEN
      IF  (  where_clause NOT LIKE 'GROUP BY%'
         AND where_clause NOT LIKE 'ORDER BY%')
      THEN
         where_clause :=
            'WHERE ' || LTRIM (where_clause, 'WHERE');
      END IF;
   END IF;
   
   DBMS_SQL.parse (cur,
   'SELECT ' || col_list || 
   '  FROM ' || table_in || ' ' || where_clause,
   DBMS_SQL.native
   );
   
   FOR col_ind IN 1 .. col_count
   LOOP
      IF is_string (col_ind)
      THEN
         DBMS_SQL.define_column (
            cur,
            col_ind,
            string_value,
            collen (col_ind)
         );
      
      ELSIF is_number (col_ind)
      THEN
         DBMS_SQL.define_column (
            cur,
            col_ind,
            number_value
         );
      
      ELSIF is_date (col_ind)
      THEN
         DBMS_SQL.define_column (cur, col_ind, date_value);
      END IF;
   END LOOP;
   
   fdbk := DBMS_SQL.execute (cur);
   
   LOOP
      fdbk := DBMS_SQL.fetch_rows (cur);
      EXIT WHEN fdbk = 0;
      
      IF DBMS_SQL.last_row_count = 1
      THEN
         p.l (col_border);
         p.l (centered_string (
                                  'Contents of ' ||
                                  table_in,
                                  line_length
                               ));
         p.l (col_border);
         p.l (col_header);
         p.l (col_border);
      END IF;
      
      col_line := NULL;
      FOR col_ind IN 1 .. col_count
      LOOP
         IF is_string (col_ind)
         THEN
            DBMS_SQL.column_value (
               cur,
               col_ind,
               string_value
            );
         
         ELSIF is_number (col_ind)
         THEN
            DBMS_SQL.column_value (
               cur,
               col_ind,
               number_value
            );
            string_value := TO_CHAR (number_value);
         
         ELSIF is_date (col_ind)
         THEN
            DBMS_SQL.column_value (
               cur,
               col_ind,
               date_value
            );
            string_value :=
               TO_CHAR (date_value, date_format_in);
         END IF;
         
         col_line :=
            col_line ||
            ' ' ||
            RPAD (
               NVL (string_value, ' '),
               collen (col_ind)
            );
      END LOOP;
      
      p.l (col_line);
   END LOOP;
   DBMS_SQL.close_cursor (cur);
EXCEPTION
   /* Dallas */
   WHEN OTHERS
   THEN
      /* Toronto 5/99: should look at SQLERRM
         BEFORE closing the cursor in case another
         error is raised! */
      p.l (SQLERRM);
      DBMS_SQL.close_cursor (cur);
END;
/
 
================================================================================
