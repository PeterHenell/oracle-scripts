CREATE OR REPLACE PROCEDURE halve_that_number ( my_number IN OUT NOCOPY NUMBER )
IS
BEGIN
   my_number := my_number / 2;
   RAISE VALUE_ERROR;
END halve_that_number;
/

DECLARE
   l_number NUMBER NOT NULL := 100;
BEGIN
   halve_that_number ( l_number );
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ( l_number );
END;
/
