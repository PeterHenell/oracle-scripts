CREATE OR REPLACE PROCEDURE showcol (
   tab IN VARCHAR2,
   col IN VARCHAR2,
   whr IN VARCHAR2 := NULL)
IS
   TYPE cv_type IS REF CURSOR;
   cv cv_type; 
   val VARCHAR2(32767);  
BEGIN
   OPEN cv FOR 
      'SELECT ' || col || 
      '  FROM ' || tab ||
      ' WHERE ' || NVL (whr, '1 = 1');
      
   LOOP
      FETCH cv INTO val;
      EXIT WHEN cv%NOTFOUND;
      IF cv%ROWCOUNT = 1
      THEN
         DBMS_OUTPUT.PUT_LINE (RPAD ('-', 60, '-'));
         DBMS_OUTPUT.PUT_LINE (
            'Contents of ' || UPPER (tab) || '.' || UPPER (col));
         DBMS_OUTPUT.PUT_LINE (RPAD ('-', 60, '-'));
      END IF;
      DBMS_OUTPUT.PUT_LINE (val);
   END LOOP;
   
   CLOSE cv;
END;
/   

      