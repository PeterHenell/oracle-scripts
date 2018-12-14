DECLARE
   TYPE list_of_names_t IS TABLE OF VARCHAR2 (32767)
                              INDEX BY PLS_INTEGER;

   happyfamily     list_of_names_t;
   l_index_value   PLS_INTEGER := 88;
BEGIN
   happyfamily (1) := 'Eli';
   happyfamily (25) := 'Steven';

   DBMS_OUTPUT.put_line (happyfamily (1));

   IF happyfamily.EXISTS (2)
   THEN
      DBMS_OUTPUT.put_line (happyfamily (2));
   ELSE
      DBMS_OUTPUT.put_line ('No name at index 2!');
   END IF;
END;
/