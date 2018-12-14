/*
Create statement level triggers on employees
*/

DROP TABLE my_employees
/

CREATE TABLE my_employees
(
   employee_id   INTEGER
 , last_name     VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO my_employees
        VALUES (100, 'FEUERSTEIN');

   INSERT INTO my_employees
        VALUES (200, 'KHUKLOVICH');

   INSERT INTO my_employees
        VALUES (300, 'FARRELL');

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE trigger_count
IS
   SUBTYPE action_t IS VARCHAR2 (100);

   PROCEDURE increment_before (action_in IN action_t);

   PROCEDURE increment_after (action_in IN action_t);

   PROCEDURE reset;

   PROCEDURE report;
END trigger_count;
/

CREATE OR REPLACE PACKAGE BODY trigger_count
IS
   TYPE count_t IS TABLE OF PLS_INTEGER
                      INDEX BY action_t;

   g_count_before   count_t;
   g_count_after    count_t;

   PROCEDURE increment_before (action_in IN action_t)
   IS
   BEGIN
      g_count_before (action_in) :=
         CASE
            WHEN NOT g_count_before.EXISTS (action_in) THEN 1
            ELSE g_count_before (action_in) + 1
         END;
   END increment_before;

   PROCEDURE increment_after (action_in IN action_t)
   IS
   BEGIN
      g_count_after (action_in) :=
         CASE
            WHEN NOT g_count_after.EXISTS (action_in) THEN 1
            ELSE g_count_after (action_in) + 1
         END;
   END increment_after;

   PROCEDURE reset
   IS
   BEGIN
      g_count_after.delete;
      g_count_before.delete;
   END reset;

   PROCEDURE report
   IS
      l_index_value   action_t;
   BEGIN
      DBMS_OUTPUT.put_line ('BEFORE STATEMENT COUNTS...');
      l_index_value := g_count_before.FIRST;

      WHILE (l_index_value IS NOT NULL)
      LOOP
         DBMS_OUTPUT.
          put_line (l_index_value || ' = ' || g_count_before (l_index_value));
         l_index_value := g_count_before.NEXT (l_index_value);
      END LOOP;

      DBMS_OUTPUT.put_line ('AFTER STATEMENT COUNTS....');
      l_index_value := g_count_after.FIRST;

      WHILE (l_index_value IS NOT NULL)
      LOOP
         DBMS_OUTPUT.
          put_line (l_index_value || ' = ' || g_count_after (l_index_value));
         l_index_value := g_count_after.NEXT (l_index_value);
      END LOOP;
   END;
END trigger_count;
/

CREATE OR REPLACE TRIGGER before_my_employees
   BEFORE UPDATE OR INSERT OR DELETE
   ON my_employees
BEGIN
   trigger_count.
    increment_before (
      CASE
         WHEN UPDATING () THEN 'UPDATE'
         WHEN DELETING () THEN 'DELETE'
         WHEN INSERTING () THEN 'INSERT'
      END);
END;
/

CREATE OR REPLACE TRIGGER after_my_employees
   AFTER UPDATE OR INSERT OR DELETE
   ON my_employees
BEGIN
   trigger_count.
    increment_after (
      CASE
         WHEN UPDATING () THEN 'UPDATE'
         WHEN DELETING () THEN 'DELETE'
         WHEN INSERTING () THEN 'INSERT'
      END);
END;
/


DECLARE
   TYPE ids_t IS TABLE OF my_employees.employee_id%TYPE
                    INDEX BY PLS_INTEGER;

   l_ids     ids_t;

   TYPE names_t IS TABLE OF my_employees.last_name%TYPE
                      INDEX BY PLS_INTEGER;

   l_names   names_t;

   PROCEDURE run_updates
   IS
   BEGIN
      FOR rec IN (SELECT * FROM my_employees)
      LOOP
         UPDATE my_employees
            SET last_name = rec.last_name;
      END LOOP;

      ROLLBACK;

      SELECT employee_id
        BULK COLLECT INTO l_ids
        FROM my_employees;

      FORALL indx IN l_ids.FIRST .. l_ids.LAST
         UPDATE my_employees
            SET last_name = last_name
          WHERE employee_id = l_ids (indx);

      ROLLBACK;
   END run_updates;

   PROCEDURE run_inserts
   IS
   BEGIN
      FOR rec IN (SELECT * FROM my_employees)
      LOOP
         INSERT INTO my_employees
              VALUES (rec.employee_id + 1, rec.last_name);
      END LOOP;

      ROLLBACK;

      SELECT employee_id + 1, last_name
        BULK COLLECT INTO l_ids, l_names
        FROM my_employees;

      FORALL indx IN l_ids.FIRST .. l_ids.LAST
         INSERT INTO my_employees
              VALUES (l_ids (indx), l_names (indx));

      ROLLBACK;
   END run_inserts;

   PROCEDURE run_deletes
   IS
   BEGIN
      FOR rec IN (SELECT * FROM my_employees)
      LOOP
         DELETE FROM my_employees
               WHERE employee_id = rec.employee_id;
      END LOOP;

      ROLLBACK;

      SELECT employee_id
        BULK COLLECT INTO l_ids
        FROM my_employees;

      FORALL indx IN l_ids.FIRST .. l_ids.LAST
         DELETE FROM my_employees
               WHERE employee_id = l_ids (indx);

      ROLLBACK;
   END run_deletes;
BEGIN
   /*
   We should see a count of 3 from the non-FORALL processing.
   So a total of 6 if FORALL fires trigger on each statement
   or a total of 4 if FORALL fires trigger just once.
   */
   trigger_count.reset;
   run_updates;
   run_inserts;
   run_deletes;
   trigger_count.report;
END;
/