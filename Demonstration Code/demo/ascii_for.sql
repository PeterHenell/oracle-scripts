CREATE OR REPLACE FUNCTION ascii_for (string_in     IN VARCHAR2
                                    , location_in   IN PLS_INTEGER DEFAULT 1)
   RETURN PLS_INTEGER
IS
BEGIN
   RETURN ASCII (SUBSTR (string_in, location_in, 1));
END ascii_for;
/

BEGIN
   DBMS_OUTPUT.put_line ('Default = ' || ascii_for ('abc'));
   DBMS_OUTPUT.put_line ('Positive = ' || ascii_for ('abc', 2));
   DBMS_OUTPUT.put_line ('With NULL = ' || ascii_for ('abc', NULL));
   DBMS_OUTPUT.put_line ('Negative = ' || ascii_for ('abcd', -2));
   DBMS_OUTPUT.put_line ('Past end of string = ' || ascii_for ('abc', 500));
END;
/