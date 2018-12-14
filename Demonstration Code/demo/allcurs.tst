CREATE OR REPLACE PROCEDURE report_with_cv (typ IN INTEGER)
IS
   cv allcurs.cv_t;
   rec allcurs.cv_rt;
BEGIN
   /* Open the specified cursor. */
   cv := allcurs.open (typ);

   IF NOT cv%ISOPEN -- cv IS NULL
   THEN
      p.l ('CV not set');
   ELSE
      /* Perform identical work, regardless of cursor
         opened. */
      LOOP
         FETCH cv INTO rec;
         EXIT WHEN cv%NOTFOUND;
         p.l (rec.nm, rec.key);
      END LOOP;

      /* Close through the cursor variable. */
      CLOSE cv;
   END IF;
END;
/
