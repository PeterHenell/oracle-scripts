ALTER SESSION SET PLSQL_CCFLAGS = 'plsql_max_string_size:32767'
/

CREATE OR REPLACE PROCEDURE work_with_big_strings 
IS
   l_big_string VARCHAR2 ( $$plsql_max_string_size );
BEGIN
   l_big_string := 'abc';
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PROCEDURE', USER, 'WORK_WITH_BIG_STRINGS');
END;
/

