CREATE TABLE test_tab (n NUMBER)
/

CREATE OR REPLACE TYPE test_ot IS OBJECT
                  (n NUMBER);
/

CREATE OR REPLACE TYPE test_nt IS TABLE OF test_ot
/

DECLARE
   -- Use for testing of equality between relational tables?
   group1    test_nt;
   group2    test_nt;
   l_count   INTEGER;
   t1        INTEGER;

   PROCEDURE load1 (e IN OUT test_nt)
   IS
   BEGIN
      SELECT ee.n
        BULK COLLECT INTO e 
        FROM test_tab ee;
   END;

   PROCEDURE load2 (e IN OUT test_nt)
   IS
   BEGIN
      SELECT ee.n
        BULK COLLECT INTO e 
        FROM test_tab ee;
   END;
BEGIN
   load1 (group1);
   load2 (group2);

   IF group1 = group2
   THEN
      NULL;
   END IF;
END;
/