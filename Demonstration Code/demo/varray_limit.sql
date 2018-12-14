DECLARE
   TYPE max_of_five_t IS VARRAY (5) OF NUMBER;

   l_list   max_of_five_t := max_of_five_t();
BEGIN
   DBMS_OUTPUT.put_line (l_list.LIMIT);
END;