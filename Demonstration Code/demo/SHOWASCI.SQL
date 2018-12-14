SET SERVEROUTPUT ON
SET VERIFY OFF
BEGIN
FOR let_index IN &&firstparm .. &&secondparm
   LOOP
      p.l ('Ascii ' || TO_CHAR (let_index) || ' = ' || 
           CHR (let_index));
   END LOOP;			
END;
/
