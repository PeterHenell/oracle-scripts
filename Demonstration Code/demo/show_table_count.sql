CREATE OR REPLACE PROCEDURE show_table_counts (
   schema_in         IN   VARCHAR2 DEFAULT USER
 , table_filter_in   IN   VARCHAR2 DEFAULT '%'
)
AUTHID CURRENT_USER
IS
   l_owners DBMS_SQL.varchar2s;
   l_tables DBMS_SQL.varchar2s;
   --
   l_query VARCHAR2 ( 32767 );
   l_count PLS_INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO l_count
     FROM all_objects
    WHERE owner = schema_in
      AND object_name LIKE table_filter_in
      AND object_type = 'TABLE';

   DBMS_OUTPUT.put_line (    'Number of tables in schema "'
                          || schema_in
                          || '" with name like "'
                          || table_filter_in
                          || '" = '
                          || l_count
                        );

   SELECT owner, object_name
   BULK COLLECT INTO l_owners, l_tables
     FROM all_objects
    WHERE owner = schema_in
      AND object_name LIKE table_filter_in
      AND object_type = 'TABLE';

   FOR indx IN 1 .. l_tables.COUNT
   LOOP
      l_query :=
            'SELECT COUNT(*) FROM '
         || l_owners ( indx )
         || '.'
         || l_tables ( indx );

      EXECUTE IMMEDIATE l_query
                   INTO l_count;

      DBMS_OUTPUT.put_line (    '   Count of rows in '
                             || l_owners ( indx )
                             || '.'
                             || l_tables ( indx )
                             || ' = '
                             || l_count
                           );
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ( 'Error: ' || DBMS_UTILITY.format_error_stack );
      DBMS_OUTPUT.put_line ( l_query );
END show_table_counts;
/

BEGIN
   show_table_counts;
   show_table_counts ( USER, 'EMP%' );
END;
/
