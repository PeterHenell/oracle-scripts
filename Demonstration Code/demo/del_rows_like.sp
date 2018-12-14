CREATE OR REPLACE PROCEDURE del_rows_like (
   table_in IN VARCHAR2
 , column_in IN VARCHAR2
 , string_in IN VARCHAR2
)
IS
BEGIN
   EXECUTE IMMEDIATE    'DELETE FROM '
                     || table_in
                     || ' WHERE '
                     || column_in
                     || ' LIKE ''%'
                     || string_in
                     || ''' OR '
                     || column_in
                     || ' LIKE '''
                     || string_in
                     || '%''';
END;
/
