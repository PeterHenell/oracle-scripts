CREATE OR REPLACE PACKAGE error_log_pkg
IS
   PROCEDURE create_table;

   PROCEDURE log_error (
      error_code_in         IN   PLS_INTEGER
    , error_message_in      IN   VARCHAR2
    , application_info_in   IN   VARCHAR2
   );
END error_log_pkg;
/

CREATE OR REPLACE PACKAGE BODY error_log_pkg
IS
   PROCEDURE create_table
   IS
      l_drop_ddl VARCHAR2 ( 1000 ) := 'DROP TABLE error_log';
      l_create_ddl VARCHAR2 ( 1000 )
$IF DBMS_DB_VERSION.VER_LE_9_2
$THEN  
         := 'CREATE TABLE error_log (
  ERROR_CODE INTEGER,
  error_message VARCHAR2(4000),
  application_info VARCHAR2(4000),
  call_stack VARCHAR2(4000),
  created_on DATE,
  created_by VARCHAR2(100)
  )';
$ELSE
         := 'CREATE TABLE error_log (
  ERROR_CODE INTEGER,
  error_message VARCHAR2(4000),
  application_info VARCHAR2(4000),
  call_stack VARCHAR2(4000),
  error_backtrace VARCHAR2(4000),
  created_on DATE,
  created_by VARCHAR2(100)
  )';
$END  
   BEGIN
      EXECUTE IMMEDIATE l_drop_ddl;
      EXECUTE IMMEDIATE l_create_ddl;
   END create_table;

   PROCEDURE log_error (
      error_code_in         IN   PLS_INTEGER
    , error_message_in      IN   VARCHAR2
    , application_info_in   IN   VARCHAR2
   )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      EXECUTE IMMEDIATE 
$IF DBMS_DB_VERSION.VER_LE_9_2
$THEN        
      'INSERT INTO error_log
                  ( ERROR_CODE, error_message, application_info
                  , call_stack, created_on, created_by
                  )
           VALUES ( :error_code, :error_message, :application_info
                  , :call_stack, SYSDATE, USER
                  )'
         USING error_code_in, error_message_in, application_info_in
             , DBMS_UTILITY.FORMAT_CALL_STACK;                 
$ELSE           
      'INSERT INTO error_log
                  ( ERROR_CODE, error_message, application_info
                  , error_backtrace
                  , call_stack, created_on, created_by
                  )
           VALUES ( :error_code, :error_message, :application_info
                  , :back_trace, :call_stack, SYSDATE, USER
                  )'
         USING error_code_in, error_message_in, application_info_in
             , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, DBMS_UTILITY.FORMAT_CALL_STACK;                 
$END
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         RAISE;
   END log_error;
END error_log_pkg;
/

BEGIN
   error_log_pkg.create_table;
   error_log_pkg.log_error ( -1403, 'yikes!', NULL );
END;
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PACKAGE BODY', USER, 'ERROR_LOG_PKG');
END;
/