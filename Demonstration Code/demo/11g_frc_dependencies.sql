CREATE TABLE plch_a (col VARCHAR2 (2));

CREATE TABLE plch_b (col VARCHAR2 (2));

INSERT INTO plch_a
     VALUES ('a1');

INSERT INTO plch_b
     VALUES ('b1');

COMMIT;

CREATE OR REPLACE FUNCTION plch_result_cache (i_table_suffix VARCHAR2)
   RETURN VARCHAR2
   RESULT_CACHE
IS
   res   VARCHAR2 (2);
BEGIN
   DBMS_OUTPUT.put_line ('SELECT FROM plch_' || i_table_suffix);

   EXECUTE IMMEDIATE 'select col from plch_' || i_table_suffix INTO res;

   RETURN res;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_result_cache ('a'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After a(1)');
   
   DBMS_OUTPUT.put_line (plch_result_cache ('b'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After b(1)');

   UPDATE plch_a
      SET col = 'a2';

   COMMIT;

   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After change to a2');

   DBMS_OUTPUT.put_line (plch_result_cache ('a'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After a(2)');
   
   DBMS_OUTPUT.put_line (plch_result_cache ('b'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After b(2)');

   UPDATE plch_b
      SET col = 'b2';

   COMMIT;

   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After change to b2');

   DBMS_OUTPUT.put_line (plch_result_cache ('a'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After a(3)');
   
   DBMS_OUTPUT.put_line (plch_result_cache ('b'));
   show_frc_dependencies ('%PLCH_RESULT_CACHE%', 'After b(3)');
END;
/

DROP FUNCTION plch_result_cache
/

DROP TABLE plch_a PURGE
/

DROP TABLE plch_b PURGE
/
