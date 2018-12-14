CREATE OR REPLACE FUNCTION instr_f (string1_in   IN VARCHAR2
                                  , string2_in   IN VARCHAR2)
   RETURN BOOLEAN
IS
   l_return     BOOLEAN;
   l_location   PLS_INTEGER;
BEGIN
   /* If either argument is null, return null */
   IF string1_in IS NOT NULL AND string2_in IS NOT NULL
   THEN
      l_location := INSTR (string1_in, string2_in);

      IF l_location = 0
      THEN
         l_return := FALSE;
      ELSE
         l_return := TRUE;
      END IF;
   END IF;

   RETURN l_return;
END;
/

DECLARE
   PROCEDURE test_it (tcn    VARCHAR2
                    , s1     VARCHAR2
                    , s2     VARCHAR2
                    , EXP    BOOLEAN)
   IS
      l_value   BOOLEAN;
   BEGIN
      l_value := instr_f (s1, s2);

      IF l_value = EXP OR (l_value IS NULL AND EXP IS NULL)
      THEN
         DBMS_OUTPUT.put_line (tcn || ' succeeded!');
      ELSE
         DBMS_OUTPUT.put_line (tcn || ' failed!');
      END IF;
   END;
BEGIN
   test_it ('End of string'
          , 'Fire'
          , 'ire'
          , TRUE);
   test_it ('Not in string'
          , 'Fire'
          , 'x'
          , FALSE);
   test_it ('Start of string'
          , 'Fire'
          , 'FL'
          , TRUE);
   test_it ('NULL str2'
          , 'Fire'
          , ''
          , NULL);
END;