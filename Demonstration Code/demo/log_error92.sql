CREATE OR REPLACE PROCEDURE log_error (
   error_in     IN   PLS_INTEGER,
   message_in   IN   VARCHAR2 := NULL
)
IS 
   v_handle              UTL_FILE.file_type;
BEGIN
   v_handle :=
      UTL_FILE.fopen (
         location          => 'ERROR_LOG_DIR',
         filename          => 'error.log',
         open_mode         => 'a',
         max_linesize      => 32767
      );
   UTL_FILE.put_line (
      FILE           => v_handle,
      buffer         =>    'Error '
                        || error_in
                        || ' occurred at '
                        || TO_CHAR (
                              SYSDATE,
                              'YYYYMMDD HH:MI:SS'
                           )
                        || ': '
                        || NVL (
                              message_in,
                              SQLERRM
                           ),
      autoflush      => TRUE
   );
   UTL_FILE.fclose (v_handle);
END; 

