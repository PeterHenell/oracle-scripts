DECLARE
   TYPE dates_t IS TABLE OF DATE
                      INDEX BY PLS_INTEGER;

   l_birth_dates   dates_t;

   PROCEDURE set_date (index_in IN INTEGER)
   IS
   BEGIN
      display_header ('Assign value to index value ' || TO_CHAR (index_in));


      l_birth_dates (index_in) := SYSDATE;
      DBMS_OUTPUT.put_line ('No problem!');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
   END set_date;
BEGIN
   set_date (2 ** 31 - 1);
   set_date (2 ** 31);
   set_date (-2 ** 31 + 1);
   set_date (-2 ** 31);
   set_date (-2 ** 31 - 1);
   set_date (NULL);
END;
/