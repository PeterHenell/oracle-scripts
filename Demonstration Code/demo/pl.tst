DECLARE
   FUNCTION my_string (len PLS_INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN RPAD ('0123456789', len, '0123456789');
   END my_string;
BEGIN
   pl ('10 in 10');
   pl (my_string (10), 10);
   pl ('20 in 10');
   pl (my_string (20), 10);
   pl ('20 in 5');
   pl (my_string (20), 5);
   pl ('100 in 50');
   pl (my_string (100), 50);
   pl ('2100 in 100');
   pl (my_string (2100), 100);
END;
/
