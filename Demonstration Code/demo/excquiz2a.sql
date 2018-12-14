DECLARE
/*
   This version demonstrates why the "local" exception section
   cannot handle/trap errors raised in declaration section.
*/
   aname VARCHAR2(5);
BEGIN
   DECLARE
      aname VARCHAR2(5) := 'Justice';
      loc INTEGER := 1;
   BEGIN
      loc := 2;
      DBMS_OUTPUT.PUT_LINE (aname);

      loc := 3;
      DELETE FROM emp;

   EXCEPTION
      WHEN VALUE_ERROR
      THEN
         DBMS_OUTPUT.PUT_LINE ('Got as far as ' || loc);
   END;
   DBMS_OUTPUT.PUT_LINE ('What error?');
EXCEPTION
   WHEN VALUE_ERROR
   THEN
      DBMS_OUTPUT.PUT_LINE ('Outer block');
END;
