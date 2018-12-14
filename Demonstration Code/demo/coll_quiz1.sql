DECLARE
   TYPE list_of_names_t IS TABLE OF employee.first_name%TYPE
      INDEX BY PLS_INTEGER;

   happyfamily   list_of_names_t;
   l_row         PLS_INTEGER;
BEGIN
   happyfamily (2 ** 31 + 100) := 'Eli';
   happyfamily (-15070) := 'Steven';
   happyfamily (-90900) := 'Chris';
   happyfamily (88) := 'Veva';

   --
   FOR l_row IN happyfamily.FIRST .. happyfamily.LAST
   LOOP
      DBMS_OUTPUT.put_line (happyfamily (l_row));
   END LOOP;
END;
/
