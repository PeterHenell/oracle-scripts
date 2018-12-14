BEGIN
   IF check_string.is_digit (l_string)
   THEN
      NULL;
   END IF;

   IF check_string.is_number (l_string)
   THEN
      NULL;
   END IF;

   IF check_string.is_identifier (l_string)
   THEN
      NULL;
   END IF;

   IF check_string.is_alpha_numeric (l_string)
   THEN
      NULL;
   END IF;
END;
