DECLARE
   l_file_exists   BOOLEAN;
   l_file_length   PLS_INTEGER;
   l_block_size    PLS_INTEGER;

   PROCEDURE bplstr (str IN VARCHAR2, val IN BOOLEAN)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         str || ' - '
         || CASE val
               WHEN TRUE THEN 'TRUE'
               WHEN FALSE THEN 'FALSE'
               ELSE 'NULL'
            END);
   END bplstr;
BEGIN
   UTL_FILE.fgetattr (location      => 'DEMO'
                    , filename      => 'temp.sql'
                    , fexists       => l_file_exists
                    , file_length   => l_file_length
                    , block_size    => l_block_size);
   bplstr ('File exists', l_file_exists);
   DBMS_OUTPUT.put_line ('File length is ' || l_file_length);
   DBMS_OUTPUT.put_line ('Block size is ' || l_block_size);
   --
   UTL_FILE.fgetattr (location      => 'DEMO'
                    , filename      => 'no such file .sql'
                    , fexists       => l_file_exists
                    , file_length   => l_file_length
                    , block_size    => l_block_size);
   bplstr ('File exists', l_file_exists);
   DBMS_OUTPUT.put_line ('File length is ' || l_file_length);
   DBMS_OUTPUT.put_line ('Block size is ' || l_block_size);
END;
/