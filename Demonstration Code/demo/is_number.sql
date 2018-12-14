BEGIN
   IF check_string.is_number ('1000')
   THEN
      DBMS_OUTPUT.put_line ('1000 IS a number');
   END IF;

   IF NOT check_string.is_number ('abc')
   THEN
      DBMS_OUTPUT.put_line ('abc IS NOT a number');
   END IF;

   IF check_string.is_number ('$100.50', '$99999.99')
   THEN
      DBMS_OUTPUT.put_line ('Handles numbers with currency symbols!');
   END IF;

   IF check_string.is_number ('975-', '9999MI')
   THEN
      DBMS_OUTPUT.put_line
                   ('Handles numbers with negative sign at end of string!');
   END IF;
END;
/