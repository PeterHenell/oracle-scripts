CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
   c_sub_length   CONSTANT PLS_INTEGER := LENGTH (substring_in);
   l_start                 PLS_INTEGER := 1;
   l_location              PLS_INTEGER;
   l_return                PLS_INTEGER := 0;
BEGIN
   LOOP
      l_location := INSTR (string_in, substring_in, l_start);
      EXIT WHEN l_location = 0;
      l_return := l_return + 1;
      l_start := l_location + c_sub_length;
   END LOOP;

   RETURN l_return;
END plch_num_instr;
/

CREATE OR REPLACE PROCEDURE plch_num_instr_test
IS
BEGIN
   DBMS_OUTPUT.put_line (plch_num_instr ('steven feuerstein', 'e'));
   DBMS_OUTPUT.put_line (plch_num_instr ('steven feuerstein', 'E'));
   DBMS_OUTPUT.put_line (plch_num_instr ('steven feuerstein', 'euer'));
   DBMS_OUTPUT.put_line (plch_num_instr ('steven feuerstein', 'x'));
   --DBMS_OUTPUT.put_line (plch_num_instr ('steven feuerstein', NULL));
END;
/

BEGIN
   plch_num_instr_test ();
END;
/

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
   c_sub_length   CONSTANT PLS_INTEGER := LENGTH (substring_in);
   l_location              PLS_INTEGER;
   l_return                PLS_INTEGER := 0;
BEGIN
   LOOP
      l_location :=
         INSTR (string_in
              , substring_in
              , 1
              , l_return + 1);
      EXIT WHEN l_location = 0;
      l_return := l_return + 1;
   END LOOP;

   RETURN l_return;
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/

/* No such built-in */

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
BEGIN
   RETURN NUM_INSTR (string_in, substring_in);
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/

/* Regular expression */

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
BEGIN
   RETURN REGEXP_COUNT (string_in, substring_in);
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/

/* Clever use of LENGTH, but only works for single character strings */

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
BEGIN
   RETURN LENGTH (string_in) - LENGTH (REPLACE (string_in, substring_in));
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/

/* Clever use of LENGTH, reagrdless of length of substring */

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
BEGIN
   RETURN (LENGTH (string_in) - LENGTH (REPLACE (string_in, substring_in)))
          / LENGTH (substring_in);
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/

/* Confusion over third and fourth arguments
   (not included as choice in question to avoid "code bloat" for
    players).
*/

CREATE OR REPLACE FUNCTION plch_num_instr (string_in      IN VARCHAR2
                                         , substring_in   IN VARCHAR2)
   RETURN PLS_INTEGER
IS
   c_sub_length   CONSTANT PLS_INTEGER := LENGTH (substring_in);
   l_location              PLS_INTEGER;
   l_return                PLS_INTEGER := 0;
BEGIN
   LOOP
      l_location :=
         INSTR (string_in
              , substring_in
              , l_return + 1
              , 1);
      EXIT WHEN l_location = 0;
      l_return := l_return + 1;
   END LOOP;

   RETURN l_return;
END plch_num_instr;
/

BEGIN
   plch_num_instr_test ();
END;
/
