DECLARE
   l_success   BOOLEAN DEFAULT TRUE;

   PROCEDURE report_failure (description_in IN VARCHAR2)
   IS
   BEGIN
      l_success := FALSE;
      DBMS_OUTPUT.put_line ('   Failure on test "' || description_in || '"'
                           );
   END report_failure;
BEGIN
   DBMS_OUTPUT.put_line ('Testing STRIPPED_STRING');

   IF stripped_string (string_in => '', strip_characters_in => '') IS NOT NULL
   THEN
      report_failure
                    ('NULL string_in and empty set of unwanted characters');
   END IF;

   IF stripped_string (string_in => '', strip_characters_in => 'ABC') IS NOT NULL
   THEN
      report_failure
                ('NULL string_in and non-empty set of unwanted characters');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => '') !=
                                                                      'ABC'
   THEN
      report_failure ('Empty set of unwanted characters');
   END IF;

   IF stripped_string (string_in => 'ABCD', strip_characters_in => 'B') !=
                                                                      'ACD'
   THEN
      report_failure
                ('Strip single occurrence of single character from string');
   END IF;

   IF stripped_string (string_in => 'ABCD', strip_characters_in => 'BD') !=
                                                                       'AC'
   THEN
      report_failure
             ('Strip single occurrence of multiple characters from string');
   END IF;

   IF stripped_string (string_in => 'ABCBD', strip_characters_in => 'B') !=
                                                                      'ACD'
   THEN
      report_failure
             ('Strip multiple occurrences of single character from string');
   END IF;

   IF stripped_string (string_in                => 'ABCDEBBDWW'
                      ,strip_characters_in      => 'BD'
                      ) != 'ACEWW'
   THEN
      report_failure
          ('Strip multiple occurrences of multiple characters from string');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => 'A') !=
                                                                       'BC'
   THEN
      report_failure ('Strip first character from string');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => 'C') !=
                                                                       'AB'
   THEN
      report_failure ('Strip last character from string');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => 'BBBB') !=
                                                                       'AC'
   THEN
      report_failure ('Duplicates in unwanted characters list');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => 'ABC') IS NOT NULL
   THEN
      report_failure ('Only unwanted characters appear in string');
   END IF;

   IF stripped_string (string_in => 'ABC', strip_characters_in => 'DEF') != 'ABC'
   THEN
      report_failure ('Unwanted characters do not appear in string');
   END IF;
         
   -- Relevant only for the REGEXP_REPLACE implementation
   IF stripped_string (string_in => 'ABC*', strip_characters_in => '*') !=
                                                                      'ABC'
   THEN
      report_failure ('Remove a * from string');
   END IF;

   -- Relevant only for the TRANSLATE implementation
   BEGIN
      IF LENGTH (stripped_string (string_in                =>    'ABC'
                                                              || CHR (1)
                                 ,strip_characters_in      => CHR (1)
                                 )
                ) != LENGTH ('ABC')
      THEN
         report_failure ('Strip out the workaround character CHR(1)');
      END IF;
   EXCEPTION
      -- With TRANSLATE version, the following error message will be
	  -- passed back. Obviously, if the error code or message raised
	  -- by stripped_string changes, this test will need to be changed, too.
      WHEN OTHERS
      THEN
         IF SQLERRM != 'ORA-20000: stripped_string error: string_in contains CHR(1).'
         THEN
            report_failure ('Strip out the workaround character CHR(1)');
         END IF;
   END;

   IF l_success
   THEN
      DBMS_OUTPUT.put_line ('Successful testing of STRIPPED_STRING!');
   END IF;
END;
/
