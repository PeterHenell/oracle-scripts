DECLARE
   l_record instance_error_log_pkg.find_record_rt;
BEGIN
   -- Cause an error to be raised.
   DBMS_OUTPUT.put_line ( TO_NUMBER ( 'abc' ));
EXCEPTION
   WHEN OTHERS
   THEN
      -- Find the entries in the cache for that error code.
      instance_error_log_pkg.find_error ( 6502, l_record );
      -- Display some information about this error code in the stack.
      DBMS_OUTPUT.put_line ( 'Total found = ' || l_record.total_found );
      DBMS_OUTPUT.put_line (    'Earliest timestamp = '
                             || TO_CHAR ( l_record.min_timestamp
                                        , 'DD-MON-YYYY HH24:MI:SS'
                                        )
                           );
      DBMS_OUTPUT.put_line (    'Latest timestamp = '
                             || TO_CHAR ( l_record.max_timestamp
                                        , 'DD-MON-YYYY HH24:MI:SS'
                                        )
                           );
      -- Save the cache to the table.
      instance_error_log_pkg.save_log ( TRUE );
END;
/

-- View the contents of the table.

SELECT *
  FROM instance_error_log
/
