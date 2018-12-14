/* Formatted by PL/Formatter v3.1.2.1 on 2001/02/15 20:59 */
/* See note in slowsql_q1.sql */

CREATE OR REPLACE PROCEDURE layoffs_plsql (disp IN BOOLEAN := FALSE)
IS
   top_layoffs   PLS_INTEGER;
   cur_layoffs   PLS_INTEGER;

   CURSOR ravaged_cur
   IS
      SELECT name || ' of ' || company slasher, layoffs
        FROM ceo_compensation
       ORDER BY layoffs DESC;

   rec           ravaged_cur%ROWTYPE;
BEGIN
   OPEN ravaged_cur;
   FETCH ravaged_cur INTO rec;

   IF disp
   THEN
      DBMS_OUTPUT.put_line ('Tops = ' || rec.slasher);
   END IF;

   LOOP
      FETCH ravaged_cur INTO rec;
      EXIT WHEN ravaged_cur%NOTFOUND;

      IF    cur_layoffs IS NULL
         OR cur_layoffs = rec.layoffs
      THEN
         IF disp
         THEN
            DBMS_OUTPUT.put_line ('Next best = ' || rec.slasher);
         END IF;
      ELSE
         EXIT;
      END IF;

      cur_layoffs := rec.layoffs;
   END LOOP;

   CLOSE ravaged_cur;
END;
/
CREATE OR REPLACE PROCEDURE layoffs_plsql2 (disp IN BOOLEAN := FALSE)
IS
   CURSOR max_cur
   IS
      SELECT name || ' of ' || company slasher, MAX (layoffs)
        FROM ceo_compensation
       GROUP BY name || ' of ' || company;

   max_rec       max_cur%ROWTYPE;

   CURSOR ravaged_cur
   IS
      SELECT name || ' of ' || company slasher, layoffs
        FROM ceo_compensation;

   ravaged_rec   ravaged_cur%ROWTYPE;
   rec           ravaged_cur%ROWTYPE;
BEGIN
   OPEN max_cur;
   FETCH max_cur INTO max_rec;
   close max_cur;

   IF disp
   THEN
      DBMS_OUTPUT.put_line ('Tops = ' || max_rec.slasher);
   END IF;

   FOR rec IN ravaged_cur
   LOOP
      IF ravaged_cur%rowcount = 1
      THEN
         ravaged_rec := rec;
      ELSIF ravaged_rec.layoffs < rec.layoffs
      THEN
         ravaged_rec := rec;
      END IF;
   END LOOP;

   IF disp
   THEN
      DBMS_OUTPUT.put_line ('Next best = ' || ravaged_rec.slasher);
   END IF;
END;
/       

