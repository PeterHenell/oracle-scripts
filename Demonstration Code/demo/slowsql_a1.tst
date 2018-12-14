@@slowsql_q1.sql
@@slowsql_a1.sql
@@tmr81.ot
SET TERMOUT OFF

DROP TABLE ceo_compensation;

CREATE TABLE ceo_compensation (
   company VARCHAR2(100),
   name VARCHAR2(100), 
   compensation NUMBER,
   layoffs NUMBER);

CREATE INDEX ceo_comp_u1 ON ceo_compensation (layoffs, company, name);

/* Populate with data, real and imaginary */
INSERT INTO ceo_compensation VALUES (
   'Mattel', 'Jill Barad', 9100000, 2700);

INSERT INTO ceo_compensation VALUES (
   'American Express Company', 'Harvey Golub', 33200000, 3300);

INSERT INTO ceo_compensation VALUES (
   'Mega Media', 'Summer Waters', 500000, 3300);

INSERT INTO ceo_compensation VALUES (
   'Eastman Kodak', 'George Fisher', 10700000, 20100);

BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      INSERT INTO ceo_compensation VALUES (
         'MoreProfits ' || indx || ', Inc.',
         'Compassionate Conservative ' || indx,
         indx * 1000,
         indx * 10);
   END LOOP;
END;
/

COMMIT;

SET TERMOUT ON

SELECT COUNT(*) FROM ceo_compensation;

@ssoo
DECLARE
   disp BOOLEAN;
   sql_tmr tmr_t := tmr_t.make ('All SQL', &&firstparm);
   plsql_tmr tmr_t := tmr_t.make ('USE PL/SQL', &&firstparm);
   nodesc_tmr tmr_t := tmr_t.make ('USE PL/SQL NO DESC', &&firstparm);
BEGIN
   disp := TRUE;
   sql_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      layoffs_sql (disp);
      IF disp THEN disp := FALSE; END IF;
   END LOOP;
   sql_tmr.stop;

   disp := TRUE;
   plsql_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      layoffs_plsql (disp);
      IF disp THEN disp := FALSE; END IF;
   END LOOP;
   plsql_tmr.stop;

   disp := TRUE;
   nodesc_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      layoffs_plsql2 (disp);
      IF disp THEN disp := FALSE; END IF;
   END LOOP;
   nodesc_tmr.stop;

/* 1000 iterations...
Tops = George Fisher of Eastman Kodak
Next best = Compassionate Conservative 1000 of MoreProfits 1000, Inc.
Elapsed time for "All SQL" = 5.57 seconds. Per repetition timing = .00557 seconds.
Tops = George Fisher of Eastman Kodak
Next best = Compassionate Conservative 1000 of MoreProfits 1000, Inc.
Elapsed time for "USE PL/SQL" = 451.18 seconds. Per repetition timing = .45118 seconds.
*/

END;
/

TRUNCATE TABLE ceo_compensation;
