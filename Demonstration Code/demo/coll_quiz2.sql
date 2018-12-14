DECLARE
   TYPE list_of_names_t IS TABLE OF VARCHAR2 (100);
   
   happyfamily   list_of_names_t;
BEGIN
   happyfamily (1) := 'Eli';
   happyfamily (2) := 'Steven';
   happyfamily (3) := 'Chris';
   happyfamily (4) := 'Veva';
END;
/
