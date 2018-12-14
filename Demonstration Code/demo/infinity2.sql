DECLARE
   l_float       BINARY_FLOAT := .95f;
   l_infinity1   BINARY_FLOAT := binary_float_infinity;
   l_infinity2   BINARY_FLOAT := binary_float_infinity;
BEGIN
   IF l_float IS INFINITE
   THEN
      sys.DBMS_OUTPUT.put_line ('That''s a REALLY big number!');
   ELSE
      sys.DBMS_OUTPUT.put_line ('That''s a finite number!');
   END IF;

   IF l_infinity1 = l_infinity2
   THEN
      sys.DBMS_OUTPUT.put_line ('Two infinities are equal!');
   ELSE
      sys.DBMS_OUTPUT.put_line ('How can two infinities be equal?');
   END IF;
END;