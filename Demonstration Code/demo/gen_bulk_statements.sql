CREATE OR REPLACE PROCEDURE gen_bulk_statements (
   base_name_in   IN   VARCHAR2
 , query_in       IN   VARCHAR2
)
IS
   c_type_names DBMS_DESCRIBE.varchar2_table;

   TYPE col_info_rt IS RECORD (
      col_name all_tab_columns.column_name%TYPE
    , col_type all_tab_columns.data_type%TYPE
   );

   TYPE col_info_aat IS TABLE OF col_info_rt
      INDEX BY PLS_INTEGER;

   l_columns col_info_aat;

   PROCEDURE load_type_translators
   IS
      c_varchar2 CONSTANT PLS_INTEGER := 1;
      c_number CONSTANT PLS_INTEGER := 2;
      c_binary_integer CONSTANT PLS_INTEGER := 3;
      c_long CONSTANT PLS_INTEGER := 8;
      c_rowid CONSTANT PLS_INTEGER := 11;
      c_date CONSTANT PLS_INTEGER := 12;
      c_raw CONSTANT PLS_INTEGER := 23;
      c_longraw CONSTANT PLS_INTEGER := 24;
      c_opaque CONSTANT PLS_INTEGER := 58;
      c_char CONSTANT PLS_INTEGER := 96;
      c_refcursor CONSTANT PLS_INTEGER := 102;
      c_urowid CONSTANT PLS_INTEGER := 104;
      c_mlslabel CONSTANT PLS_INTEGER := 106;
      c_clob CONSTANT PLS_INTEGER := 112;
      c_blob CONSTANT PLS_INTEGER := 113;
      c_bfile CONSTANT PLS_INTEGER := 114;
      c_cfile CONSTANT PLS_INTEGER := 115;
      c_object_type CONSTANT PLS_INTEGER := 121;
      c_nested_table CONSTANT PLS_INTEGER := 122;
      c_varray CONSTANT PLS_INTEGER := 123;
      c_timestamp CONSTANT PLS_INTEGER := 180;
      c_timestamp_tz CONSTANT PLS_INTEGER := 181;
      c_interval_ym CONSTANT PLS_INTEGER := 182;
      c_interval_ds CONSTANT PLS_INTEGER := 183;
      c_timestamp_ltz CONSTANT PLS_INTEGER := 231;
      c_record CONSTANT PLS_INTEGER := 250;
      c_indexby_table CONSTANT PLS_INTEGER := 251;
      c_boolean CONSTANT PLS_INTEGER := 252;
   BEGIN
      c_type_names ( c_varchar2 ) := 'VARCHAR2';
      c_type_names ( c_number ) := 'NUMBER';
      c_type_names ( c_binary_integer ) := 'BINARY_INTEGER';
      c_type_names ( c_long ) := 'LONG';
      c_type_names ( c_rowid ) := 'ROWID';
      c_type_names ( c_date ) := 'DATE';
      c_type_names ( c_raw ) := 'RAW';
      c_type_names ( c_longraw ) := 'LONG RAW';
      c_type_names ( c_char ) := 'CHAR';
      c_type_names ( c_mlslabel ) := 'MLSLABEL';
      c_type_names ( c_record ) := 'RECORD';
      c_type_names ( c_indexby_table ) := 'INDEX-BY TABLE';
      c_type_names ( c_boolean ) := 'BOOLEAN';
      c_type_names ( c_object_type ) := 'OBJECT TYPE';
      c_type_names ( c_nested_table ) := 'NESTED TABLE';
      c_type_names ( c_varray ) := 'VARRAY';
      c_type_names ( c_clob ) := 'CLOB';
      c_type_names ( c_blob ) := 'BLOB';
      c_type_names ( c_bfile ) := 'BFILE';
   END load_type_translators;

   FUNCTION columns_for_query ( query_in IN VARCHAR2 )
      RETURN col_info_aat
   IS
      cur PLS_INTEGER := DBMS_SQL.open_cursor;
      l_count PLS_INTEGER;
      l_from_dbms_sql DBMS_SQL.desc_tab;
      retval col_info_aat;
   BEGIN
      -- Parse the query and then get the columns.
      DBMS_SQL.parse ( cur, query_in, DBMS_SQL.native );
      DBMS_SQL.describe_columns ( cur, l_count, l_from_dbms_sql );
      DBMS_SQL.close_cursor ( cur );

      -- Now move the "raw" data to my list of names and types.
      -- In particular, convert the integer type to the string description.
      FOR colind IN 1 .. l_from_dbms_sql.COUNT
      LOOP
         retval ( colind ).col_name := l_from_dbms_sql ( colind ).col_name;
         retval ( colind ).col_type :=
            CASE
               WHEN c_type_names ( l_from_dbms_sql ( colind ).col_type ) IN
                                                        ( 'VARCHAR2', 'CHAR' )
                  THEN    c_type_names ( l_from_dbms_sql ( colind ).col_type )
                       || '(32767)'
               ELSE c_type_names ( l_from_dbms_sql ( colind ).col_type )
            END;
      END LOOP;

      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ( DBMS_UTILITY.format_error_stack );
         DBMS_SQL.close_cursor ( cur );
         RAISE;
   END columns_for_query;

   PROCEDURE initialize ( columns_out OUT col_info_aat )
   IS
   BEGIN
      load_type_translators;
      columns_out := columns_for_query ( query_in );
   END initialize;

   PROCEDURE gen_declarations ( columns_in IN col_info_aat )
   IS
   BEGIN
      DBMS_OUTPUT.put_line ( 'DECLARE TYPE ' || base_name_in
                             || '_rt IS RECORD ('
                           );

      FOR colind IN 1 .. columns_in.COUNT
      LOOP
         DBMS_OUTPUT.put_line (    CASE
                                      WHEN colind = 1
                                         THEN NULL
                                      ELSE ','
                                   END
                                || columns_in ( colind ).col_name
                                || ' '
                                || columns_in ( colind ).col_type
                              );
      END LOOP;

      DBMS_OUTPUT.put_line ( ');' );
      DBMS_OUTPUT.put_line (    'TYPE '
                             || base_name_in
                             || '_ct IS TABLE OF '
                             || base_name_in
                             || '_rt INDEX BY PLS_INTEGER;'
                           );
   END gen_declarations;

   PROCEDURE gen_bulk_query_and_insert ( columns_in IN col_info_aat )
   IS
   BEGIN
      -- First, with collections of records.
      DBMS_OUTPUT.put_line ( 'l_dataset ' || base_name_in || '_ct;' );
      DBMS_OUTPUT.put_line (    'CURSOR '
                             || base_name_in
                             || '_cur IS '
                             || query_in
                             || ';'
                           );
      DBMS_OUTPUT.put_line ( 'BEGIN' );
      DBMS_OUTPUT.put_line ( 'OPEN ' || base_name_in || '_cur;' );
      DBMS_OUTPUT.put_line (    'FETCH '
                             || base_name_in
                             || '_cur BULK COLLECT INTO l_dataset;'
                           );
      DBMS_OUTPUT.put_line ( 'END;' );
      -- Now break out the individual collections, necessary if you are going to
      -- use these in a FORALL statement.
      DBMS_OUTPUT.put_line ( 'DECLARE' );

      FOR colind IN 1 .. columns_in.COUNT
      LOOP
         DBMS_OUTPUT.put_line (    'TYPE '
                                || columns_in ( colind ).col_name
                                || '_aat IS TABLE OF '
                                || columns_in ( colind ).col_type
                                || ' INDEX BY PLS_INTEGER;'
                              );
         DBMS_OUTPUT.put_line (    'l_'
                                || columns_in ( colind ).col_name
                                || ' '
                                || columns_in ( colind ).col_name
                                || '_aat;'
                              );
      END LOOP;

      DBMS_OUTPUT.put_line (    'CURSOR '
                             || base_name_in
                             || '_cur IS '
                             || query_in
                             || ';'
                           );
      DBMS_OUTPUT.put_line ( 'BEGIN' );
      DBMS_OUTPUT.put_line ( 'OPEN ' || base_name_in || '_cur;' );
      DBMS_OUTPUT.put_line ( 'FETCH ' || base_name_in
                             || '_cur BULK COLLECT INTO '
                           );

      FOR colind IN 1 .. columns_in.COUNT
      LOOP
         -- Display other attributes, as desired.
         DBMS_OUTPUT.put_line (    CASE
                                      WHEN colind = 1
                                         THEN NULL
                                      ELSE ','
                                   END
                                || 'l_'
                                || columns_in ( colind ).col_name
                              );
      END LOOP;

      DBMS_OUTPUT.put_line ( ';' );
      -- Now the insert statement.
      DBMS_OUTPUT.put_line (    'FORALL indx IN '
                             || 'l_'
                             || columns_in ( 1 ).col_name
                             || '.FIRST .. '
                             || 'l_'
                             || columns_in ( 1 ).col_name
                             || '.LAST'
                           );
      DBMS_OUTPUT.put_line ( 'INSERT INTO ' || base_name_in || ' VALUES (' );

      FOR colind IN 1 .. columns_in.COUNT
      LOOP
         -- Display other attributes, as desired.
         DBMS_OUTPUT.put_line (    CASE
                                      WHEN colind = 1
                                         THEN NULL
                                      ELSE ','
                                   END
                                || 'l_'
                                || columns_in ( colind ).col_name
                              );
      END LOOP;

      DBMS_OUTPUT.put_line ( '); END;' );
   END gen_bulk_query_and_insert;
BEGIN
   initialize ( l_columns );

   IF l_columns.COUNT > 0
   THEN
      gen_declarations ( l_columns );
      gen_bulk_query_and_insert ( l_columns );
   END IF;
END gen_bulk_statements;
/
