/* Formatted by PL/Formatter v3.1.2.1 on 2001/05/14 09:40 */

DECLARE
   once_tmr    tmr_t
                    := tmr_t.make ('Explicit', &&1);
   every_tmr   tmr_t      := tmr_t.make ('CV', &&1);

   CURSOR cur
   IS
      SELECT *
        FROM emp;

   type cv_t is ref cursor return emp%rowtype;
   cv cv_t;
   rec         cur%ROWTYPE;
BEGIN
   once_tmr.go;

   FOR indx IN 1 .. &&1
   LOOP
      OPEN cur;
      FETCH cur INTO rec;
      CLOSE cur;
   END LOOP;

   once_tmr.stop;
   every_tmr.go;

   FOR indx IN 1 .. &&1
   LOOP
      OPEN cv FOR
         SELECT *
           FROM emp;
      FETCH cv INTO rec;
      CLOSE cv;
   END LOOP;

   every_tmr.stop;
END;
/


