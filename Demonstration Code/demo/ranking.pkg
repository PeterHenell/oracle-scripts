DROP TABLE rank_sales;

CREATE TABLE rank_sales (
   dept_id NUMBER,
   salesperson_id NUMBER,
   sales_amt NUMBER,
   ranking NUMBER);

INSERT INTO rank_sales
     VALUES (10, 100, 1000, 4);
INSERT INTO rank_sales
     VALUES (10, 120, 10000, 1);
INSERT INTO rank_sales
     VALUES (10, 111, 10000, 2);
INSERT INTO rank_sales
     VALUES (10, 300, 9999, 1);
INSERT INTO rank_sales
     VALUES (50, 1900, 10000, 1);
INSERT INTO rank_sales
     VALUES (50, 1820, 1000, 2);
INSERT INTO rank_sales
     VALUES (50, 1911, 100, 3);

CREATE OR REPLACE PACKAGE RANK
IS
   PROCEDURE add_dept (
      dept_id_in   IN   INTEGER
   );

   PROCEDURE rank_depts;

   PROCEDURE perform_ranking (
      dept_id_in   IN   INTEGER
   );
END rank;
/

CREATE OR REPLACE PACKAGE BODY RANK
IS
   in_process   BOOLEAN      := FALSE;

   TYPE dept_tabtype IS TABLE OF BOOLEAN
      INDEX BY BINARY_INTEGER;

   dept_tab     dept_tabtype;

   PROCEDURE add_dept (
      dept_id_in   IN   INTEGER
   )
   IS
   BEGIN
      IF NOT in_process
      THEN
         pl (dept_id_in);
         dept_tab (dept_id_in) := TRUE;
      END IF;
   END add_dept;

   PROCEDURE perform_ranking (
      dept_id_in   IN   INTEGER
   )
   IS
   BEGIN
      FOR rec IN  (SELECT   *
                       FROM rank_sales
                      WHERE dept_id =
                               dept_id_in
                   ORDER BY sales_amt)
      LOOP
         pl (
               rec.dept_id
            || '-'
            || rec.salesperson_id
         );
		 -- UPDATE...
      END LOOP;
   END;

   PROCEDURE rank_depts
   IS
      v_deptid   PLS_INTEGER
                      := dept_tab.FIRST;

      PROCEDURE cleanup
      IS
      BEGIN
         in_process := FALSE;
         dept_tab.DELETE;
      END;
   BEGIN
      IF NOT in_process
      THEN
         in_process := TRUE;

         LOOP
            EXIT WHEN v_deptid IS NULL;
            perform_ranking (v_deptid);
            v_deptid :=
               dept_tab.NEXT (v_deptid);
         END LOOP;
      END IF;

      cleanup; -- Moorgate 9/2001
   EXCEPTION
      -- 7/2000 Solomon Yakobson says:
      -- Make sure cleanup occurs when error is raised.

      -- Call cleanup; inside each exception handler
      WHEN NO_DATA_FOUND
      THEN
         cleanup;
      WHEN OTHERS
      THEN
         cleanup;
         RAISE;
   END rank_depts;
END rank;
/

CREATE OR REPLACE TRIGGER rank_sales_rtrg
   AFTER INSERT OR UPDATE OF sales_amt
   ON rank_sales
   FOR EACH ROW
   WHEN (OLD.sales_amt != NEW.sales_amt)
BEGIN
   RANK.add_dept (:NEW.dept_id);
END;
/

CREATE OR REPLACE TRIGGER rank_sales_strg
   AFTER INSERT OR UPDATE OR DELETE
   ON rank_sales
BEGIN
   RANK.rank_depts;
END;
/

UPDATE rank_sales
   SET sales_amt = 3000
 WHERE salesperson_id = 1820
/
 

