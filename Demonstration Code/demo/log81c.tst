/* Demonstrates nesting of auton transactions. */

DROP TABLE emp2;

CREATE TABLE emp2
AS
   SELECT * FROM emp;

CREATE OR REPLACE FUNCTION table_count (
   owner_in        IN all_tables.owner%TYPE,
   table_name_in   IN all_tables.table_name%TYPE)
   RETURN PLS_INTEGER
   AUTHID CURRENT_USER
IS
   l_return   PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE
         'SELECT COUNT(*) FROM '
      || owner_in
      || '.'
      || table_name_in
      INTO l_return;

   RETURN l_return;
END;
/

CREATE OR REPLACE PROCEDURE test_auton
IS
   PROCEDURE auton
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      DELETE FROM emp2;

      DBMS_OUTPUT.put_line (
         'internal emp2 ' || table_count (USER, 'emp2'));
      logpkg.saveline (0, 'Deleted all from emp2');
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
         ROLLBACK;
         RAISE;
   END;
BEGIN
   --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   DBMS_OUTPUT.put_line ('emp2 ' || table_count (USER, 'emp2'));
   DBMS_OUTPUT.put_line (
      'logtab ' || table_count (USER, 'logtab'));
   auton;
   DBMS_OUTPUT.put_line ('emp2 ' || table_count (USER, 'emp2'));
   DBMS_OUTPUT.put_line (
      'logtab ' || table_count (USER, 'logtab'));
END;
/

BEGIN
   test_auton;
END;
/