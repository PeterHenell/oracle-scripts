DROP TABLE t_vc2
/

CREATE OR REPLACE TYPE nt_vc2_20x IS TABLE OF VARCHAR2 ( 20 )
/

CREATE TABLE t_vc2 (v VARCHAR2(1000))
/

DECLARE
   lvnt nt_vc2_20x := nt_vc2_20x ( );
BEGIN
   lvnt.EXTEND ( 3 );
   lvnt ( 1 ) := 'ONE';
   lvnt ( 2 ) := 'TEN';
   lvnt ( 3 ) := 'HUNDRED';

   INSERT INTO t_vc2
      SELECT relational_lvnt.COLUMN_VALUE
        FROM TABLE ( lvnt ) relational_lvnt;
END;
/

SELECT *
  FROM t_vc2
/
