CREATE TABLE plch_a (col VARCHAR2 (2));

CREATE TABLE plch_b (col VARCHAR2 (2));

INSERT INTO plch_a
     VALUES ('a1');

INSERT INTO plch_b
     VALUES ('b1');

COMMIT;

CREATE OR REPLACE FUNCTION plch_result_cache
   RETURN VARCHAR2
   RESULT_CACHE
IS
   res   VARCHAR2 (2);
BEGIN
   DBMS_OUTPUT.put_line ('Hello!');

   SELECT col INTO res FROM plch_a;

   IF res = 'a2'
   THEN
      SELECT col INTO res FROM plch_b;
   END IF;

   RETURN res;
END;
/

DECLARE
   s   VARCHAR2 (100);
BEGIN
   s := plch_result_cache;
   show_frc_dependencies ('%PLCH_RESULT_CACHE%');
END;
/

DECLARE
   s   VARCHAR2 (100);
BEGIN
   s := plch_result_cache;

   UPDATE plch_b
      SET col = 'b2';

   COMMIT;
   s :=plch_result_cache;
   show_frc_dependencies ('%PLCH_RESULT_CACHE%');
END;
/

DECLARE
   s   VARCHAR2 (100);
BEGIN
   s := plch_result_cache;

   UPDATE plch_a
      SET col = 'a2';

   COMMIT;
   s :=plch_result_cache;
   show_frc_dependencies ('%PLCH_RESULT_CACHE%');
END;
/

DROP TABLE plch_a PURGE;
DROP TABLE plch_b PURGE;
DROP FUNCTION plch_result_cache;