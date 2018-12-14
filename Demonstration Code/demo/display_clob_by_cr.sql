CREATE OR REPLACE PROCEDURE display_clob_by_cr (
   clob_in   IN CLOB
 , dir_in    IN VARCHAR2 DEFAULT NULL
 , file_in   IN VARCHAR2 DEFAULT 'clob.txt')
IS
   l_lines   qu_config.maxvarchar2_aat;

   PROCEDURE clob_to_code_lines (
      clob_in       IN            CLOB
    , lines_inout   IN OUT NOCOPY qu_config.maxvarchar2_aat)
   IS
      c_array_max   CONSTANT PLS_INTEGER DEFAULT 32767;
      c_length      CONSTANT PLS_INTEGER := LENGTH (clob_in);
      l_string               VARCHAR2 (32767);
      l_start                PLS_INTEGER := 1;
      l_latest_delim         PLS_INTEGER := 1;
   BEGIN
      WHILE (l_start <= c_length AND l_latest_delim <> 0)
      LOOP
         l_latest_delim := INSTR (clob_in, CHR (10), l_start);

         IF l_latest_delim = 0
         THEN
            /* We are done, just grab the rest. */
            l_string := SUBSTR (clob_in, l_start);
         ELSE
            l_string := SUBSTR (clob_in, l_start, l_latest_delim - l_start);
            l_start := l_latest_delim + 1;
         END IF;

         lines_inout (lines_inout.COUNT + 1) := l_string;
      END LOOP;
   END clob_to_code_lines;
BEGIN
   clob_to_code_lines (clob_in, l_lines);

   FOR indx IN 1 .. l_lines.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_lines (indx));
   END LOOP;

   IF dir_in IS NOT NULL
   THEN
      DECLARE
         l_file   UTL_FILE.file_type;
      BEGIN
         l_file :=
            UTL_FILE.fopen (dir_in
                          , file_in
                          , 'W'
                          , max_linesize   => 32767);

         FOR indx IN 1 .. l_lines.COUNT
         LOOP
            UTL_FILE.put_line (l_file, l_lines (indx));
         END LOOP;

         UTL_FILE.fclose (l_file);
      END;
   END IF;
END display_clob_by_cr;
/