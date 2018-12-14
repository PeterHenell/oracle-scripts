/*
All values are stored as expressions.
*/

CREATE TABLE string_test_table
(
   string_test_id   INTEGER PRIMARY KEY
 ,  input_value      VARCHAR2 (4000)
 ,  expected_value   VARCHAR2 (4000)
);
/

CREATE OR REPLACE PACKAGE string_manipulation
AS
   FUNCTION doublestring (string_in IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION repeatstring (string_in   IN VARCHAR2
                        ,  repeat_in   IN INTEGER)
      RETURN VARCHAR2;

   FUNCTION repeatstring2 (string_in   IN VARCHAR2
                         ,  repeat_in   IN INTEGER)
      RETURN VARCHAR2;

   PROCEDURE test_dstring (param1_in   IN VARCHAR2
                         ,  param2_in   IN VARCHAR2
                         ,  param3_in   IN VARCHAR2);

   PROCEDURE test_dstring2;

   PROCEDURE test_dstring3;

   PROCEDURE test_dstring4;
END string_manipulation;
/

CREATE OR REPLACE PACKAGE BODY string_manipulation
AS
   FUNCTION doublestring (string_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN string_in || string_in;
   END;

   FUNCTION repeatstring (string_in   IN VARCHAR2
                        ,  repeat_in   IN INTEGER)
      RETURN VARCHAR2
   IS
      repeat_string_var   VARCHAR2 (1000);
   BEGIN
      FOR c IN 1 .. repeat_in
      LOOP
         repeat_string_var := repeat_string_var || string_in;
      END LOOP;

      RETURN repeat_string_var;
   END;

   FUNCTION repeatstring2 (string_in   IN VARCHAR2
                         ,  repeat_in   IN INTEGER)
      RETURN VARCHAR2
   IS
      repeat_string_var   VARCHAR2 (1000);
   BEGIN
      RETURN RPAD ('', repeat_in, string_in);
   END;

   PROCEDURE test_dstring (param1_in   IN VARCHAR2
                         ,  param2_in   IN VARCHAR2
                         ,  param3_in   IN VARCHAR2)
   IS
      test1           VARCHAR2 (1000);
      test2           VARCHAR2 (1000);
      test3           VARCHAR2 (1000);
      test1_success   VARCHAR2 (1000);
      test2_success   VARCHAR2 (1000);
      test3_success   VARCHAR2 (1000);
      test1_text      VARCHAR2 (1000);
      test2_text      VARCHAR2 (1000);
      test3_text      VARCHAR2 (1000);
   BEGIN
      test1 := doublestring (string_in => param1_in);

      IF test1 = param1_in || param1_in
      THEN
         test1_success := 'Success';
      ELSE
         test1_success := 'Failure';
      END IF;

      test1_text :=
         'Result:' || test1 || ', ' || test1_success;
      DBMS_OUTPUT.put_line (test1_text);

      test2 := doublestring (string_in => param2_in);

      IF test2 = param2_in || param2_in
      THEN
         test2_success := 'Success';
      ELSE
         test2_success := 'Failure';
      END IF;

      test2_text :=
         'Result:' || test2 || ', ' || test2_success;

      DBMS_OUTPUT.put_line (test2_text);

      test3 := doublestring (string_in => param3_in);

      IF test3 = param3_in || param3_in
      THEN
         test3_success := 'Success';
      ELSE
         test3_success := 'Failure';
      END IF;

      test3_text :=
         'Result:' || test3 || ', ' || test3_success;

      DBMS_OUTPUT.put_line (test3_text);
   END;

   PROCEDURE test_dstring2
   IS
      l_overall_result   BOOLEAN := TRUE;

      PROCEDURE test_one (input_in      IN VARCHAR2
                        ,  expected_in   IN VARCHAR2)
      IS
         l_thisresult   VARCHAR2 (32767);
      BEGIN
         l_thisresult := doublestring (string_in => input_in);

         IF (   l_thisresult = expected_in
             OR (    l_thisresult IS NULL
                 AND expected_in IS NULL))
         THEN
            NULL;
         ELSE
            l_overall_result := FALSE;
            DBMS_OUTPUT.put_line (
                  'Expected:'
               || expected_in
               || ', Got:'
               || l_thisresult);
         END IF;
      END;
   BEGIN
      test_one ('a', 'aa');
      test_one ('abc', 'abcabc');
      test_one ('1', '11');
      test_one ('', '');
      DBMS_OUTPUT.put_line (
         CASE
            WHEN l_overall_result THEN 'Success'
            ELSE 'Failure'
         END);
   END;

   PROCEDURE test_dstring3
   IS
      l_overall_result   BOOLEAN := TRUE;

      PROCEDURE test_one (input_in      IN VARCHAR2
                        ,  expected_in   IN VARCHAR2)
      IS
         l_thisresult   VARCHAR2 (32767);
      BEGIN
         l_thisresult := doublestring (string_in => input_in);

         IF (   l_thisresult = expected_in
             OR (    l_thisresult IS NULL
                 AND expected_in IS NULL))
         THEN
            NULL;
         ELSE
            l_overall_result := FALSE;
            DBMS_OUTPUT.put_line (
                  'Expected:'
               || expected_in
               || ', Got:'
               || l_thisresult);
         END IF;
      END;
   BEGIN
      FOR c IN (SELECT * FROM string_test_table)
      LOOP
         test_one (c.input_value, c.expected_value);
      END LOOP;

      DBMS_OUTPUT.put_line (
         CASE
            WHEN l_overall_result THEN 'Success'
            ELSE 'Failure'
         END);
   END;

   PROCEDURE test_dstring4
   IS
      l_overall_result   BOOLEAN := TRUE;

      PROCEDURE test_one (input_in      IN VARCHAR2
                        ,  expected_in   IN VARCHAR2)
      IS
         l_thisresult   VARCHAR2 (32767);
      BEGIN
         EXECUTE IMMEDIATE
               'BEGIN :result := doublestring (string_in => '
            || input_in
            || '); END;'
            USING l_thisresult;

         IF (   l_thisresult = expected_in
             OR (    l_thisresult IS NULL
                 AND expected_in IS NULL))
         THEN
            NULL;
         ELSE
            l_overall_result := FALSE;
            DBMS_OUTPUT.put_line (
                  'Expected:'
               || expected_in
               || ', Got:'
               || l_thisresult);
         END IF;
      END;
   BEGIN
      FOR c IN (SELECT * FROM string_test_table)
      LOOP
         test_one (c.input_value, c.expected_value);
      END LOOP;

      DBMS_OUTPUT.put_line (
         CASE
            WHEN l_overall_result THEN 'Success'
            ELSE 'Failure'
         END);
   END;
END string_manipulation;
/

/* Run the test with literals */

BEGIN
   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (1, 'a', 'aa');

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (2, 'abc', 'abcabc');

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (3, '1', '11');

   COMMIT;
END;
/

EXEC string_manipulation.test_dstring3

/* Run the test with expressions */

BEGIN
   DELETE FROM string_test_table;

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (1, '''a''', '''aa''');

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (2, '''abc''', '''abcabc''');

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (3, '''1''', '''11''');

   INSERT
     INTO string_test_table (string_test_id
                           ,  input_value
                           ,  expected_value)
   VALUES (
             4
           ,  'RPAD (''a'', ''a'', 32767)'
           ,  'RPAD (''a'', ''a'', 65534)');

   COMMIT;
END;
/

EXEC string_manipulation.test_dstring4

/* Clean up */

DROP TABLE string_test_table
/

DROP PACKAGE string_manipulation
/