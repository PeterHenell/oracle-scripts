CREATE OR REPLACE PROCEDURE show_char_chunks (your_name_in    VARCHAR2
                                            , numchar_in      INTEGER)
IS
   c_length   CONSTANT INTEGER := LENGTH (your_name_in);
   l_letters           VARCHAR2 (50);
   l_stringloc         INTEGER := 1;
BEGIN
   ASSERT.is_true (numchar_in <= 50, 'Maximum chunk size allowed is 50.');
   /*
   IF numchar_in > 50
   THEN
      raise_application_error (-20000, 'Maximum chunk size allowed is 50.');
   END IF;
   */

   loop_killer.kill_after (50);

   LOOP
      l_letters := SUBSTR (your_name_in, l_stringloc, numchar_in);
      DBMS_OUTPUT.put_line (l_letters);
      EXIT WHEN l_stringloc + numchar_in = c_length;
      l_stringloc := l_stringloc + numchar_in;
      loop_killer.increment_or_kill;
   END LOOP;
END;
/

BEGIN
   show_char_chunks (RPAD ('abc', 100, 'def'), 60);
END;
/