CREATE OR REPLACE PROCEDURE showcol (
   tab   IN   VARCHAR2
 , col   IN   VARCHAR2
 , whr   IN   VARCHAR2 := NULL
)
IS
   cv    sys_refcursor; -- Oracle9iR2
   val   VARCHAR2 (32767);
BEGIN
   OPEN cv FOR 'SELECT ' || col || '  FROM ' || tab || ' WHERE ' || whr;

   LOOP
      FETCH cv
       INTO val;

      EXIT WHEN cv%NOTFOUND;
      DBMS_OUTPUT.put_line (val);
   END LOOP;

   CLOSE cv;
END;