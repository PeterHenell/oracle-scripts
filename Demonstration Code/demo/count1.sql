@@tmr10g.ot

CREATE TABLE lotsa_data (NAME VARCHAR2(100));

BEGIN
   FOR indx IN 1 .. 100000
   LOOP
      INSERT INTO lotsa_data
           VALUES ('Name ' || indx);
   END LOOP;

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE count1_test (count_in IN PLS_INTEGER := 100000)
IS
   l_count         PLS_INTEGER;
   count1_tmr      tmr_t       := NEW tmr_t ('COUNT(1)', count_in);
   countstar_tmr   tmr_t       := NEW tmr_t ('COUNT(*)', count_in);
BEGIN
   count1_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      SELECT COUNT (1)
        INTO l_count
        FROM lotsa_data;
   END LOOP;

   count1_tmr.STOP;
   countstar_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      SELECT COUNT (*)
        INTO l_count
        FROM lotsa_data;
   END LOOP;

   countstar_tmr.STOP;
END;
/

BEGIN
   count1_test (1000);
END;
/

DROP TABLE lotsa_data;