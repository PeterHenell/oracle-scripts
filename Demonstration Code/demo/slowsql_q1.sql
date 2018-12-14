/*
Note: as of 9/99 this ALL SQL version runs significantly faster
than the PL/SQL version in slowsql_a1.sql, contrary to expectations
set by reading Guy Harrison's book. I am not sure what I am doing
in my example to "ruin" this tuning tip...

SF
*/

@@dropwhatever.sp
exec drop_whatever ('ceo_compensation', 'table');

CREATE TABLE ceo_compensation (
   company VARCHAR2(100),
   name VARCHAR2(100),
   compensation NUMBER,
   layoffs INTEGER);

CREATE OR REPLACE PROCEDURE layoffs_sql (disp IN BOOLEAN := FALSE)
IS
   CURSOR tops_cur
   IS
   SELECT name || ' of ' || company Slasher1
     FROM ceo_compensation
    WHERE layoffs =
          (SELECT MAX (layoffs)
             FROM ceo_compensation);

   CURSOR almost_cur
   IS
   SELECT name || ' of ' || company Slasher2
     FROM ceo_compensation
    WHERE layoffs =
          (SELECT MAX (layoffs)
             FROM ceo_compensation
            WHERE layoffs != 
                     (SELECT MAX (layoffs)
                        FROM ceo_compensation));
BEGIN
   FOR rec IN tops_cur
   LOOP
      IF disp THEN DBMS_OUTPUT.PUT_LINE ('Tops = ' || rec.slasher1); END IF;
   END LOOP;
   
   FOR rec IN almost_cur                     
   LOOP
      IF disp THEN DBMS_OUTPUT.PUT_LINE ('Next best = ' || rec.slasher2); END IF;
   END LOOP;
END;
/                     
