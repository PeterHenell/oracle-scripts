DECLARE
   c_null           NUMBER := NULL;

   /* Specify a range of values */
   SUBTYPE month_number_t IS PLS_INTEGER RANGE 1 .. 12;

   /* Constrain the subtype from the base type */
   SUBTYPE my_number1_t IS NUMBER (4, 2);

   /* Constrain a subtype from another subtype */
   SUBTYPE my_number2_t IS my_number1_t (4, 2);

   /* Specify NOT NULL */
   SUBTYPE required_integer_t IS INTEGER NOT NULL;

   l_month_number   month_number_t;
   l_number_42      my_number1_t;
   l_number_42_st   my_number2_t;
   l_required       required_integer_t := 10 /* Try it without initial value! */
                                            ;
BEGIN
   BEGIN
      l_month_number := 13;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      l_number_42 := 10000;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      l_number_42_st := 10000;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;

   BEGIN
      /* COMPILE ERROR for this:

      l_required := null;

      */
      l_required := c_null;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END;
END;