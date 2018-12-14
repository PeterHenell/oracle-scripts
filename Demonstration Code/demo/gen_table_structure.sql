BEGIN
   FOR rec IN (SELECT   table_name, column_name, data_type, column_id
                   FROM all_tab_columns atc
                  WHERE atc.owner = USER
               ORDER BY table_name, column_id)
   LOOP
      DBMS_OUTPUT.put_line (   'col_info_out('
                            || ''''
                            || rec.table_name
                            || ''')('
                            || rec.column_id
                            || ').column_name := '''
                            || rec.column_name
                            || ''';'
                           );
      DBMS_OUTPUT.put_line (   'col_info_out('
                            || ''''
                            || rec.table_name
                            || ''')('
                            || rec.column_id
                            || ').column_name := '''
                            || rec.data_type
                            || ''';'
                           );
   END LOOP;
END;
/
