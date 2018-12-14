CREATE OR REPLACE DIRECTORY demo AS 'c:\D-DRIVE\demo-seminar'
/

DECLARE
   PROCEDURE bpl (val IN BOOLEAN)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ('TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ('FALSE');
      ELSE
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END;
BEGIN
   q$error_manager.set_trace (TRUE);
   q$error_manager.toscreen;
   bpl (fileio92.fexists ('DEMO', 'fexists.tst'));
   bpl (fileio92.fexists ('DEMO', 'fexists.tstX'));
END;
/