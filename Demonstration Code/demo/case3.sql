CREATE OR REPLACE PROCEDURE plch_show_ranking (
   rank_in IN PLS_INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE
         WHEN rank_in <= 25 THEN 'Top Ranked'
         ELSE rank_in
      END);
END;
/

BEGIN
   plch_show_ranking (1);
   plch_show_ranking (37);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_ranking (
   rank_in IN PLS_INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE rank_in 
          WHEN <= 25 THEN 'Top Ranked'
          ELSE rank_in
      END);
END;
/

BEGIN
   plch_show_ranking (1);
   plch_show_ranking (37);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_ranking (
   rank_in IN PLS_INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      IF rank_in <= 25 THEN 'Top Ranked'
      ELSE TO_CHAR (rank_in)
      END IF);
END;
/

BEGIN
   plch_show_ranking (1);
   plch_show_ranking (37);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_ranking (
   rank_in IN PLS_INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      CASE
         WHEN rank_in <= 25 THEN 'Top Ranked'
         ELSE TO_CHAR (rank_in)
      END);
END;
/

BEGIN
   plch_show_ranking (1);
   plch_show_ranking (37);
END;
/

/* Clean up */

DROP PROCEDURE plch_show_ranking
/