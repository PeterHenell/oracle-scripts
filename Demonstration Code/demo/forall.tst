DROP TABLE parts;

CREATE TABLE parts (
   partnum NUMBER,
   partname VARCHAR2(15)
   );
   
CREATE OR REPLACE PROCEDURE compare_inserting (num IN INTEGER)
IS
   TYPE NumTab IS TABLE OF parts.partnum%TYPE INDEX BY BINARY_INTEGER;
   TYPE NameTab IS TABLE OF parts.partname%TYPE INDEX BY BINARY_INTEGER;
   pnums NumTab;
   pnames NameTab;
BEGIN
   FOR indx IN 1..num LOOP
      pnums(indx) := indx;
      pnames(indx) := 'Part ' || TO_CHAR(indx);
   END LOOP;
   
   sf_timer.start_timer;
   FOR indx IN 1..num LOOP
      INSERT INTO parts VALUES (pnums(indx), pnames(indx));
   END LOOP;
   sf_timer.show_elapsed_time ('FOR loop '|| num);
   
   ROLLBACK;
   
   sf_timer.start_timer;
   FORALL indx IN 1..num
      INSERT INTO parts VALUES (pnums(indx), pnames(indx));
   sf_timer.show_elapsed_time ('FORALL '|| num);
   
   ROLLBACK;
END;
/
BEGIN
   compare_inserting (1000);
   compare_inserting (10000);
   compare_inserting (100000);
END;
/   

