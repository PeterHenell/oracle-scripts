CREATE TABLE plch_test_dep (n NUMBER)
/

CREATE VIEW plch_test_dep_v
AS
   SELECT * FROM plch_test_dep;

CREATE OR REPLACE PROCEDURE plch_test_dep_proc
IS
   l   INTEGER;
BEGIN
   SELECT COUNT (*) INTO l FROM plch_test_dep_v;
END;
/

  SELECT owner || '.' || name refs_table,
         referenced_owner || '.' || referenced_name table_referenced
    FROM all_dependencies
   WHERE     owner = USER
         AND referenced_type IN ('TABLE', 'VIEW')
         AND referenced_name like 'PLCH_TEST_DEP%'
ORDER BY owner,
         name,
         referenced_owner,
         referenced_name
/         

/* Not yet working correctly; shows TOO MUCH data */

    SELECT pd.object_id,
           do.object_name,
           referenced_object_id,
           dor.object_name,
           LEVEL
      FROM public_dependency pd,
           user_objects uo,
           user_objects do,
           user_objects dor
     WHERE     uo.object_name = 'PLCH_TEST_DEP'
           AND uo.object_type = 'TABLE'
           AND do.object_id = pd.object_id
           AND dor.object_id = pd.referenced_object_id
CONNECT BY PRIOR pd.object_id = referenced_object_id
START WITH referenced_object_id = uo.object_id
/

/* Clean up */

DROP TABLE plch_test_dep
/

DROP VIEW plch_test_dep_v
/

DROP PROCEDURE plch_test_dep_proc
/