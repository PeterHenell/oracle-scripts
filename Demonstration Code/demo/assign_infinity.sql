DECLARE
   n   NUMBER;
BEGIN
   BEGIN
      DBMS_OUTPUT.put_line ('Assign literal');

      /* If I use static code, get a compile error:
           PLS-00569: numeric overflow or underflow
      */
      EXECUTE IMMEDIATE 'begin :n := 1e126; end;' USING OUT n;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   /* Nothing else causes overflow... */
   
   BEGIN
      DBMS_OUTPUT.put_line ('Assign expression');
      n := 1e125 * 10;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      DBMS_OUTPUT.put_line ('Assign string');
      n := '1e126';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      DBMS_OUTPUT.put_line ('Assign BINARY_FLOAT_INFINITY');
      n := binary_float_infinity;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      DBMS_OUTPUT.put_line ('Assign BINARY_DOUBLE_INFINITY');
      n := binary_double_infinity;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;
END;
/