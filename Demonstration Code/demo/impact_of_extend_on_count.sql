DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers.EXTEND ();
   l_numbers (1) := 100;
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers.EXTEND ();
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
END;
/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers.EXTEND (2);
   l_numbers (1) := 100;
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers (2) := 100;
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
END;
/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers.EXTEND (2);
   l_numbers (1) := 100;
   l_numbers.DELETE (1);
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers (2) := 100;
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
END;
/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t := numbers_t ();
BEGIN
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers.EXTEND (2);
   l_numbers (1) := 100;
   l_numbers.DELETE (1);
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
   l_numbers (1) := 200;
   l_numbers (2) := 100;
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
END;
/