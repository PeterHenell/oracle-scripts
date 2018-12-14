/*
Testing framework for DBMS_UTILITY.NAME_RESOLVE

Context values:

Must be an integer between 0 and 9.
¡ 0 - table
¡ 1 - PL/SQL (for 2 part names)
¡ 2 - sequences
¡ 3 - trigger
¡ 4 - Java Source
¡ 5 - Java resource
¡ 6 - Java class
¡ 7 - type
¡ 8 - Java shared data
¡ 9 - index

Part1 Types:

¡ 5 - synonym
¡ 7 - procedure (top level)
¡ 8 - function (top level)
¡ 9 - package

Note: on 10g, if you try a context of 0 you see this:

ORA-20005: ORU-10034: context argument must be 1 or 2 or 3 or 4 or 5 or 6 or 7

May only be supported in Oracle11g.

*/

DROP TABLE test_name_resolve
/
CREATE TABLE test_name_resolve (
test_case_name VARCHAR2(100),
setup_code VARCHAR2(4000),
   NAME  VARCHAR2(100)
 , CONTEXT  NUMBER
 , SCHEMA VARCHAR2(100)
 , part1 VARCHAR2(100)
 , part2 VARCHAR2(100)
 , dblink VARCHAR2(100)
 , part1_type NUMBER
 , object_number NUMBER)
/

BEGIN
   INSERT INTO test_name_resolve
               (test_case_name, setup_code, NAME, CONTEXT, "SCHEMA", part1
              , part2, dblink, part1_type, object_number
               )
        VALUES ('Local table', NULL, 'employees', NULL, NULL, NULL
              , NULL, NULL, NULL, NULL
               );
END;
/

CREATE OR REPLACE FUNCTION name_resolve_func
   RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END;
/

CREATE SYNONYM ls_name_resolve_func FOR name_resolve_func;
CREATE PUBLIC SYNONYM ps_name_resolve_func FOR name_resolve_func;
CREATE SYNONYM ls_ls_name_resolve_func FOR ls_name_resolve_func;
CREATE PUBLIC SYNONYM ps_ps_name_resolve_func FOR ps_name_resolve_func;
CREATE SYNONYM ls_ps_name_resolve_func FOR ps_name_resolve_func;
CREATE PUBLIC SYNONYM ps_ls_name_resolve_func FOR ls_name_resolve_func;

DECLARE
   PROCEDURE TEST (NAME IN VARCHAR2)
   IS
      SCHEMA          VARCHAR2 (100);
      part1           VARCHAR2 (100);
      part2           VARCHAR2 (100);
      dblink          VARCHAR2 (100);
      part1_type      NUMBER;
      object_number   NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line ('NAME_RESOLVE OF ' || NAME);
      DBMS_UTILITY.name_resolve (NAME
                               , 1
                               , SCHEMA
                               , part1
                               , part2
                               , dblink
                               , part1_type
                               , object_number
                                );
      DBMS_OUTPUT.put_line ('>   ' || SCHEMA);
      DBMS_OUTPUT.put_line ('>   ' || part1 || '-' || part2);
      DBMS_OUTPUT.put_line ('>   ' || part1_type);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('>   ' || DBMS_UTILITY.format_error_stack ());
   END;
BEGIN
   TEST ('ls_name_resolve_func');
   TEST ('ps_name_resolve_func');
   TEST ('ps_name_resolve_func');
   TEST ('ls_ls_name_resolve_func');
   TEST ('ls_ps_name_resolve_func');
   TEST ('ps_ls_name_resolve_func');
   TEST ('ps_ps_name_resolve_func');
   TEST (USER || '.ls_name_resolve_func');
   TEST (USER || '.ps_name_resolve_func');
   TEST (USER || '.ps_name_resolve_func');
   TEST (USER || '.ls_ls_name_resolve_func');
   TEST (USER || '.ls_ps_name_resolve_func');
   TEST (USER || '.ps_ls_name_resolve_func');
   TEST (USER || '.ps_ps_name_resolve_func');
END;
/