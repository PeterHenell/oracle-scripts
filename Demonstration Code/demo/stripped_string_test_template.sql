DECLARE
   l_success               BOOLEAN          DEFAULT TRUE;

   -- Variables for each IN argument
   l_string_in             VARCHAR2 (32767);
   l_strip_characters_in   VARCHAR2 (32767);

   -- Variable for function return value
   l_stripped_string       VARCHAR2 (32767);

   PROCEDURE report_failure (description_in IN VARCHAR2)
   IS
   BEGIN
      l_success := FALSE;
      DBMS_OUTPUT.put_line ('   Failure on test "' || description_in || '"'
                           );
   END report_failure;
BEGIN
   DBMS_OUTPUT.put_line ('Testing STRIPPED_STRING');
   
   -- Start test case here
   l_string_in := 'INVALUE';
   l_strip_characters_in := 'INVALUE';
   l_stripped_string :=
      stripped_string (string_in                => l_string_in
                      ,strip_characters_in      => l_strip_characters_in
                      );

   -- Check value returned by function
   IF l_stripped_string != 'EXPECTEDVALUE'
   THEN
      report_failure ('TESTCASE');
   END IF;

   --End test case here
   
   IF l_success
   THEN
      DBMS_OUTPUT.put_line ('Successful testing of STRIPPED_STRING!');
   END IF;
END;
/