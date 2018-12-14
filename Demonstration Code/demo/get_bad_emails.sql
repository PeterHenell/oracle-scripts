CREATE OR REPLACE PROCEDURE read_and_write_to_table (
   read_file_in      IN   VARCHAR2
  ,read_dir_in       IN   VARCHAR2
  ,write_table_in    IN   VARCHAR2
  ,write_column_in   IN   VARCHAR2
  ,create_table_in   IN   BOOLEAN DEFAULT FALSE
)
IS
/*

To: name@company.com
From: info@company.com

   ----- The following addresses had permanent fatal errors -----
<name@company.com>

Failed Recipient: name@company.com

*/
   l_file_in     UTL_FILE.file_type;
   l_save_line   VARCHAR2 (32767);
   l_line        VARCHAR2 (32767);
   l_eof         BOOLEAN;

   TYPE names_tt IS TABLE OF BOOLEAN
      INDEX BY VARCHAR2 (1000);

   l_names       names_tt;

   PROCEDURE get_next_line_from_file (
      file_in    IN       UTL_FILE.file_type
     ,line_out   OUT      VARCHAR2
     ,eof_out    OUT      BOOLEAN
   )
   IS
   BEGIN
      UTL_FILE.get_line (file_in, line_out);
      eof_out := FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         line_out := NULL;
         eof_out := TRUE;
   END get_next_line_from_file;

   PROCEDURE add_address (addr IN VARCHAR2)
   IS
      l_addr   VARCHAR2 (32767)
                 := LOWER (LTRIM (RTRIM (LTRIM (RTRIM (addr, '>'), '<'))));
   BEGIN
      IF l_names.EXISTS (l_addr)
      THEN
         NULL;
      ELSE
         -- Write out the previous email address.
         EXECUTE IMMEDIATE    'INSERT INTO '
                           || write_table_in
                           || '('
                           || write_column_in
                           || ') VALUES (:value)'
                     USING IN l_addr;

         COMMIT;
         l_names (l_addr) := TRUE;
      END IF;
   END add_address;
BEGIN
   l_file_in :=
      UTL_FILE.fopen (LOCATION          => read_dir_in
                     ,filename          => read_file_in
                     ,open_mode         => 'R'
                     ,max_linesize      => 32767
                     );

   IF create_table_in
   THEN
      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE ' || write_table_in;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      EXECUTE IMMEDIATE    'CREATE TABLE '
                        || write_table_in
                        || '('
                        || write_column_in
                        || ' VARCHAR2(4000))';
   END IF;

   LOOP
      get_next_line_from_file (l_file_in, l_line, l_eof);

      IF UPPER (l_line) LIKE 'FAILED RECIPIENT:%'
      THEN
         add_address (SUBSTR (l_line, INSTR (l_line, ':') + 1));
      ELSIF l_line LIKE
              '%----- The following addresses had permanent fatal errors -----%'
      THEN
         -- Remove next address.
         get_next_line_from_file (l_file_in, l_line, l_eof);

         IF NOT l_eof AND l_line LIKE '<%>%'
         THEN
            add_address (l_line);
         END IF;
      ELSIF UPPER (REPLACE (l_line, 'A ', 'A')) LIKE 'TO:%'
      THEN
         l_save_line := UPPER (REPLACE (l_line, 'A ', 'A'));
         get_next_line_from_file (l_file_in, l_line, l_eof);

         IF     NOT l_eof
            AND UPPER (l_line) LIKE 'FROM:%INFO@REFUSERSOLIDARITY.NET%'
         THEN
            l_save_line := SUBSTR (l_save_line, 4);
            add_address (l_save_line);
         END IF;
      END IF;

      EXIT WHEN l_eof;
   END LOOP;

   UTL_FILE.fclose (l_file_in);
EXCEPTION
   WHEN OTHERS
   THEN
      UTL_FILE.fclose (l_file_in);
      RAISE;
END read_and_write_to_table;
/