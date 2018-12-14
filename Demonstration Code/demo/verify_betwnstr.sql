CREATE OR REPLACE FUNCTION betwnstr (string_in   IN VARCHAR2
                                   , start_in    IN INTEGER
                                   , end_in      IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN (SUBSTR (string_in, start_in, end_in - start_in + 1));
END betwnstr;
/

CREATE OR REPLACE PROCEDURE verify_betwnstr (string_in     IN VARCHAR2
                                           , start_in      IN INTEGER
                                           , end_in        IN INTEGER
                                           , expected_in   IN VARCHAR2)
IS
   l_string   VARCHAR2 (32767);
BEGIN
   l_string := betwnstr (string_in, start_in, end_in);

   IF l_string <> expected_in
   THEN
      DBMS_OUTPUT.
       put_line (
         'Failure for ' || string_in || '-' || start_in || '-' || end_in);
   ELSE
      DBMS_OUTPUT.
       put_line (
         'Success for ' || string_in || '-' || start_in || '-' || end_in);
   END IF;
END verify_betwnstr;
/

BEGIN
   verify_betwnstr ('abcdefg'
                  , 1
                  , 3
                  , 'abc');
   verify_betwnstr (''
                  , 1
                  , 3
                  , 'abc');
   verify_betwnstr ('abcdefg'
                  , 3
                  , 3
                  , 'c');
END;
/