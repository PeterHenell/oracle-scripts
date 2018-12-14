/* Formatted on 2003/05/08 16:18 (Formatter Plus v4.7.0) */
CREATE SEQUENCE onoffflag_seq;

CREATE OR REPLACE FUNCTION mapactiveflag (activeflag IN NUMBER)
   RETURN NUMBER
--DETERMINISTIC
IS
   mappedactiveflag   NUMBER;
BEGIN
   IF activeflag = 1
   THEN
      SELECT onoffflag_seq.NEXTVAL
        INTO mappedactiveflag
        FROM DUAL;
   ELSE
      mappedactiveflag := 0;
   END IF;

   RETURN mappedactiveflag;
END;
/