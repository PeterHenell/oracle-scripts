DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   l_numbers.EXTEND (100);
   DBMS_OUTPUT.put_line ('LIMIT=' || l_numbers.LIMIT);
END;
/

DECLARE
   TYPE numbers_t IS VARRAY (1000) OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   l_numbers.EXTEND (100);
   DBMS_OUTPUT.put_line ('LIMIT=' || l_numbers.LIMIT);
END;
/

DECLARE
   TYPE numbers_t IS VARRAY (100) OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   DBMS_OUTPUT.put_line ('LIMIT=' || l_numbers.LIMIT);
END;
/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER
                        INDEX BY PLS_INTEGER;

   l_numbers   numbers_t;
BEGIN
   FOR indx IN 1 .. 100
   LOOP
      l_numbers (indx * 1000) := 1;
   END LOOP;

   DBMS_OUTPUT.put_line ('LIMIT=' || l_numbers.LIMIT);
END;
/