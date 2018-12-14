REM Turns out you CANNOT hide literals!

CREATE OR REPLACE PACKAGE hide_and_seek1
IS
   secret_data VARCHAR2(100) := 'YOU CAN''T SEE ME!';
END;
/
CREATE OR REPLACE PACKAGE hide_and_seek2
IS
   secret_data VARCHAR2(100);
END;
/
CREATE OR REPLACE PACKAGE BODY hide_and_seek2
IS
BEGIN
   secret_data := 'YOU CAN''T SEE ME!';
END;
/
CREATE OR REPLACE PACKAGE hide_and_seek3
IS
   FUNCTION secret_data RETURN VARCHAR2;
END;
/
CREATE OR REPLACE PACKAGE BODY hide_and_seek
IS
   FUNCTION secret_data RETURN VARCHAR2 IS 
   BEGIN
      RETURN 'YOU CAN''T SEE ME!';
   END;
END;
/
   
   