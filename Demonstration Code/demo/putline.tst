SET ServerOutput On

DECLARE
   c_location   CONSTANT VARCHAR2 (80)
      := 'UTL_FILE_TEST'
                        ;
   c_filename   CONSTANT VARCHAR2 (80)
                                    := 'test.txt';
   v_handle              UTL_FILE.file_type;

BEGIN
      v_handle :=
         UTL_FILE.fopen (
            location          => c_location,
            filename          => c_filename,
            open_mode         => 'w',
            max_linesize      => 32767
         );
         
               UTL_FILE.put_line (
         FILE           => v_handle,
         buffer         => 'Error ' || error_in || ' occurred at ' || 
         TO_CHAR (sysdate, 'YYYYMMDD HH:MI:SS'),
         autoflush      => TRUE
      );

      FOR linenum IN 1 .. 100
      LOOP
         put_line_flush ('abc');
      END LOOP;

      UTL_FILE.fclose (v_handle);
   END LOOP;

   flush_tmr.STOP;
   noflush_tmr.go;

   FOR test_countdown IN 1 .. 100
   LOOP
      v_handle :=
         UTL_FILE.fopen (
            location          => c_location,
            filename          => c_filename,
            open_mode         => 'w',
            max_linesize      => 32767
         );

      FOR linenum IN 1 .. 100
      LOOP
         put_line ('abc');
      END LOOP;

      UTL_FILE.fclose (v_handle);
   END LOOP;

   noflush_tmr.STOP;
END;

