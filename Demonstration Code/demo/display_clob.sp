CREATE OR REPLACE PROCEDURE display_clob (clob_in IN CLOB)
IS
   l_amount     PLS_INTEGER    := 255;
   l_buffer     VARCHAR2 (255);
   l_position   PLS_INTEGER    := 1;
BEGIN
   LOOP
      DBMS_LOB.READ (clob_in, l_amount, l_position, l_buffer);
      DBMS_OUTPUT.put_line (l_buffer);
      l_position := l_position + l_amount;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND OR VALUE_ERROR
   THEN
      DBMS_OUTPUT.put_line ('** End of data');
END;
/