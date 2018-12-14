CREATE TYPE cvarray_t AS VARRAY (100) OF INTEGER;
/

CREATE OR REPLACE FUNCTION cvarray_f
   RETURN cvarray_t
IS
   ret   cvarray_t := cvarray_t (1);
BEGIN
   RETURN ret;
END;
/

DECLARE
   n   CONSTANT cvarray_t := cvarray_f;
BEGIN
   DBMS_OUTPUT.put_line (n (1));
   n (1) := 2;
   DBMS_OUTPUT.put_line (n (2));
END;
/
