CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN n1_in = n2_in;
END;
/

CREATE OR REPLACE PROCEDURE plch_test_are_equal
IS
   PROCEDURE bpl (str IN VARCHAR2, val IN BOOLEAN)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Should be ' || str || ' and = '
         || CASE val
               WHEN TRUE THEN 'TRUE'
               WHEN FALSE THEN 'FALSE'
               ELSE 'NULL'
            END);
   END;
BEGIN
   bpl ('TRUE', plch_are_equal (1, 1));
   bpl ('FALSE', plch_are_equal (1, 0));
   bpl ('FALSE', plch_are_equal (1, NULL));
   bpl ('TRUE', plch_are_equal (NULL, NULL));
   bpl ('FALSE', plch_are_equal (NULL, 0));
   bpl ('FALSE', plch_are_equal (-999999999, NULL));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('n1_in = n2_in');
   plch_test_are_equal;
END;
/

CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN NVL (n1_in, -999999999) = NVL (n2_in, -999999999);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'NVL (n1_in, -999999999) = NVL (n2_in, -999999999');
   plch_test_are_equal;
END;
/

CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN n1_in = n2_in OR n1_in IS NULL AND n2_in IS NULL;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'n1_in = n2_in OR n1_in IS NULL AND n2_in IS NULL');
   plch_test_are_equal;
END;
/

CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN n1_in = n2_in
          OR (n1_in IS NULL AND n2_in IS NULL);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'n1_in = n2_in OR (n1_in IS NULL AND n2_in IS NULL)');
   plch_test_are_equal;
END;
/

CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN n1_in = n2_in
          OR (n1_in IS NULL AND n2_in IS NULL);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'n1_in = n2_in OR (n1_in IS NULL AND n2_in IS NULL)');
   plch_test_are_equal;
END;
/

CREATE OR REPLACE FUNCTION plch_are_equal (
   n1_in   IN NUMBER
 , n2_in   IN NUMBER)
   RETURN BOOLEAN
IS
BEGIN
   RETURN NVL (n1_in = n2_in, FALSE)
          OR (n1_in IS NULL AND n2_in IS NULL);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'NVL (n1_in = n2_in, FALSE) OR (n1_in IS NULL AND n2_in IS NULL)');
   plch_test_are_equal;
END;
/