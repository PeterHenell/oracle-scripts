CREATE OR REPLACE FUNCTION if4 (val IN VARCHAR2) RETURN INTEGER
IS
   retval INTEGER;
BEGIN
   IF val = 'SMITH' THEN retval := 1;
   ELSIF val = 'SCOTT' THEN retval := 2;
   ELSIF val = 'FORD' THEN retval := 3;
   ELSIF val = 'MILLER' THEN retval := 4;
   END IF;
   RETURN retval;
END;
/
CREATE OR REPLACE PROCEDURE compare_ifdec (counter IN INTEGER)
IS
BEGIN
   sf_timer.start_timer;
   FOR ind IN 1 .. counter
   LOOP
      FOR rec IN 
      (SELECT DECODE (ename, 'SMITH', 1, 'SCOTT', 2, 'FORD', 3, 'MILLER', 4)
        FROM emp)
      LOOP
         NULL;
      END LOOP;   
   END LOOP;   
   sf_timer.show_elapsed_time ('decode');

   sf_timer.start_timer;
   FOR ind IN 1 .. counter
   LOOP
      FOR rec IN (SELECT if4 (ename) FROM emp)
      LOOP
         NULL;
      END LOOP;   
   END LOOP;   
   sf_timer.show_elapsed_time ('if');
END;
/
