CREATE OR REPLACE TYPE nt_vc2_20 AS TABLE OF VARCHAR2 ( 20 );
/

DROP TABLE t_vc2
/
CREATE TABLE t_vc2 (a VARCHAR2(20))
/

DECLARE
   lvnt nt_vc2_20 := nt_vc2_20 ( NULL );
BEGIN
   lvnt ( 1 ) := 'ONE';
   lvnt.EXTEND;
   lvnt ( 2 ) := 'TEN';
   lvnt.EXTEND;
   lvnt ( 3 ) := 'HUNDRED';

   INSERT INTO t_vc2
      SELECT cast_lvnt.COLUMN_VALUE
        FROM TABLE ( CAST ( lvnt AS nt_vc2_20 )) cast_lvnt;
END;
/
