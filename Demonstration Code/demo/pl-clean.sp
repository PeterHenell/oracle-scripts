CREATE OR REPLACE PROCEDURE pl (
   str IN VARCHAR2, len IN INTEGER := 80, expand_in in BOOLEAN := TRUE)
IS
   v_len PLS_INTEGER := LEAST (len, 255);
   v_str VARCHAR2(2000);
BEGIN
   IF LENGTH (str) > v_len
   THEN
      v_str := SUBSTR (str, 1, v_len);
      DBMS_OUTPUT.PUT_LINE (v_str);
      pl (substr (str, len + 1), v_len, expand_in);
   ELSE
      v_str := str;
      DBMS_OUTPUT.PUT_LINE (v_str);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      IF expand_in THEN 
         DBMS_OUTPUT.ENABLE (1000000); 
         DBMS_OUTPUT.PUT_LINE (v_str);
      ELSE 
         RAISE; 
      END IF;      
END pl;
/
