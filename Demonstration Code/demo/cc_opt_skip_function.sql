DROP TABLE delete_all_tab
/
CREATE TABLE delete_all_tab (
   n NUMBER
)
/

BEGIN
   INSERT INTO delete_all_tab
        VALUES (1);

   INSERT INTO delete_all_tab
        VALUES (2);

   INSERT INTO delete_all_tab
        VALUES (3);

   INSERT INTO delete_all_tab
        VALUES (4);

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION delete_all
   RETURN BOOLEAN
IS
BEGIN
   DELETE FROM delete_all_tab;

   RETURN TRUE;
END;
/

CREATE OR REPLACE PROCEDURE delete_all_test
IS
BEGIN
   IF delete_all () AND FALSE
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   delete_all_test;
END;
/

SELECT *
  FROM delete_all_tab
/
ROLLBACK
/

CREATE OR REPLACE PROCEDURE delete_all_test
IS
BEGIN
   IF FALSE AND delete_all ()
   THEN
      NULL;
   END IF;
END;
/

BEGIN
   delete_all_test;
END;
/

SELECT *
  FROM delete_all_tab
/
ROLLBACK
/
/*
Table dropped.
Table created.
PL/SQL procedure successfully completed.
Function created.
Procedure created.
PL/SQL procedure successfully completed.
no rows selected.
Rollback complete.
*/