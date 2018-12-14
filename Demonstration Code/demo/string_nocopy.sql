DECLARE
   l_inc                            PLS_INTEGER;
   l_iterations            CONSTANT PLS_INTEGER     := 10000000;
   l_testvalue                      VARCHAR2 (4000);
   l_last_cpu_time                  PLS_INTEGER;
   l_last_check_time                PLS_INTEGER;
   l_do_some_assignments   CONSTANT BOOLEAN         := TRUE;

   PROCEDURE test_inout (val IN OUT VARCHAR2)
   IS
   BEGIN
      IF l_do_some_assignments
      THEN
         val := 'some literal string';
      ELSE
         NULL;
      END IF;
   END;

   FUNCTION test_fn (val IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      IF l_do_some_assignments
      THEN
         RETURN 'some literal string';
      ELSE
         RETURN NULL;
      END IF;
   END;

   PROCEDURE test_inout_ncpy (val IN OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      IF l_do_some_assignments
      THEN
         val := 'some literal string';
      ELSE
         NULL;
      END IF;
   END;
BEGIN
   l_last_check_time := DBMS_UTILITY.get_time;

   FOR l_inc IN 1 .. l_iterations
   LOOP
      test_inout (val => l_testvalue);
   END LOOP;

   DBMS_OUTPUT.put_line (   'test_inout: '
                         || TO_CHAR (DBMS_UTILITY.get_time - l_last_check_time)
                        );
   l_last_check_time := DBMS_UTILITY.get_time;

   FOR l_inc IN 1 .. l_iterations
   LOOP
      l_testvalue := test_fn (val => l_testvalue);
   END LOOP;

   DBMS_OUTPUT.put_line (   'test_fn: '
                         || TO_CHAR (DBMS_UTILITY.get_time - l_last_check_time)
                        );
   l_last_check_time := DBMS_UTILITY.get_time;

   FOR l_inc IN 1 .. l_iterations
   LOOP
      test_inout_ncpy (val => l_testvalue);
   END LOOP;

   DBMS_OUTPUT.put_line (   'test_inout_ncpy: '
                         || TO_CHAR (DBMS_UTILITY.get_time - l_last_check_time)
                        );
/*
test_inout: 444
test_fn: 372
test_inout_ncpy: 294
*/                        
END;
/