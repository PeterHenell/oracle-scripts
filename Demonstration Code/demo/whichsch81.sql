SET ECHO ON
SET FEEDBACK ON
SET VERIFY ON

SPOOL whichsch.log

CONNECT SCOTT/TIGER

CREATE OR REPLACE PROCEDURE runddl (
   ddl_in   IN   VARCHAR2
)
AUTHID CURRENT_USER
IS
BEGIN
   EXECUTE IMMEDIATE ddl_in;
EXCEPTION               -- 4/2002 in De Meern
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line
                        (   'RUNDDL ERROR: '
                         || SQLERRM
                        );
      DBMS_OUTPUT.put_line (ddl_in);
      DBMS_OUTPUT.put_line
              (DBMS_UTILITY.format_call_stack);
      RAISE;
END;
/

GRANT EXECUTE ON runddl TO PUBLIC;

CONNECT demo/demo
@ssoo

DROP TABLE demo_table;

DESC demo_table

EXEC scott.runddl ('CREATE TABLE demo_table (col1 DATE)');

DESC demo_table

CREATE OR REPLACE PROCEDURE create_table
AS
BEGIN
   scott.runddl
      ('CREATE TABLE demo_table2 (col1 DATE)'
      );
END;
/

EXEC create_table

DESC demo_table2