CREATE TABLE codexpert_table (col NUMBER)
/

CREATE OR REPLACE PACKAGE codexpert_pkg
IS
   n   NUMBER;
END;
/

CREATE OR REPLACE FUNCTION codexpert_test (arg_in IN NUMBER)
   RETURN NUMBER
AS
   l_checking    BOOLEAN      := FALSE;
   l_checking2   VARCHAR2 (1) := 'abc';

   PROCEDURE why_did_i_write_this
   IS
   BEGIN
      DBMS_OUTPUT.put_line (arg_in);
      DBMS_OUTPUT.put_line ('Why did I write this?');
   END;
BEGIN
   l_checking2 := 'def';
   codexpert_pkg.n := 'abc';

   IF l_checking OR codexpert_pkg.n > 10
   THEN
      DBMS_OUTPUT.put_line ('Never here...');
      RETURN gl;
   ELSIF SYSDATE > SYSDATE - 1
   THEN
      FOR rec IN (SELECT *
                    FROM all_source)
      LOOP
         UPDATE codexpert_table
            SET col = arg_in;
      END LOOP;

      RETURN 1;
   ELSE
      DBMS_OUTPUT.put_line ('Always here...');
      GOTO end_of_function;
   END IF;

   <<end_of_function>>
   NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END plw6002;
/