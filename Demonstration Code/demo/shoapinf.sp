CREATE OR REPLACE PROCEDURE showapinfo
IS
   CURSOR ai_cur
   IS
      SELECT module, action
        FROM V$SESSION
       WHERE username = USER;
BEGIN
   FOR rec IN ai_cur
   LOOP
      IF ai_cur%ROWCOUNT = 1
      THEN
         p.l ('Application Information for ' || USER);
      END IF;
      p.l (rec.module, rec.action);
   END LOOP; 
END;
/
