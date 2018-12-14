DECLARE
   l_success   BOOLEAN DEFAULT TRUE;

   PROCEDURE report_failure (description_in IN VARCHAR2)
   IS
   BEGIN
      l_success := FALSE;
      DBMS_OUTPUT.put_line ('strip_characters failure!');
      DBMS_OUTPUT.put_line ('   ' || description_in);
   END report_failure;
BEGIN
   IF strip_characters ('abc', 'b') != 'ac'
   THEN
      report_failure ('Default placeholder');
   END IF;

   IF strip_characters ('abc', 'abc') IS NOT NULL
   THEN
      report_failure ('All characters removed');
   END IF;

   IF strip_characters (NULL, 'abc') IS NOT NULL
   THEN
      report_failure ('NULL input string');
   END IF;
      
   IF strip_characters ('abcdefb', 'b') != 'acdef'
   THEN
      report_failure ('Repeats of character');
   END IF;

   IF strip_characters ('abc', 'a', '#') != 'bc'
   THEN
      report_failure ('# as placeholder');
   END IF;

   IF strip_characters ('abc', NULL) != 'abc'
   THEN
      report_failure ('NULL character list');
   END IF;

   IF l_success
   THEN
      DBMS_OUTPUT.put_line ('strip_characters passed its tests!');
   END IF;
END;
/