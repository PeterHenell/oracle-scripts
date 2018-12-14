CREATE OR REPLACE PROCEDURE clob_to_file (p_filename   IN VARCHAR2,
                                            p_dir        IN VARCHAR2,
                                            p_clob       IN CLOB)
/*
Written by Hunbug
http://www.astral-consultancy.co.uk/cgi-bin/hunbug/doco.cgi?11070
*/
IS
   c_amount   CONSTANT BINARY_INTEGER := 32767;
   l_buffer            VARCHAR2 (32767);
   l_chr10             PLS_INTEGER;
   l_cloblen           PLS_INTEGER;
   l_fhandler          UTL_FILE.file_type;
   l_pos               PLS_INTEGER := 1;
BEGIN
   l_cloblen := DBMS_LOB.getlength (p_clob);
   l_fhandler :=
      UTL_FILE.fopen (p_dir,
                      p_filename,
                      'W',
                      c_amount);

   WHILE l_pos < l_cloblen
   LOOP
      l_buffer := DBMS_LOB.SUBSTR (p_clob, c_amount, l_pos);
      EXIT WHEN l_buffer IS NULL;
      l_chr10 := INSTR (l_buffer, CHR (10), -1);

      IF l_chr10 != 0
      THEN
         l_buffer := SUBSTR (l_buffer, 1, l_chr10 - 1);
      END IF;

      UTL_FILE.put_line (l_fhandler, l_buffer, TRUE);
      l_pos := l_pos + LEAST (LENGTH (l_buffer) + 1, c_amount);
   END LOOP;

   UTL_FILE.fclose (l_fhandler);
EXCEPTION
   WHEN OTHERS
   THEN
      IF UTL_FILE.is_open (l_fhandler)
      THEN
         UTL_FILE.fclose (l_fhandler);
      END IF;

      RAISE;
END;
/