CREATE OR REPLACE PROCEDURE plch_injection_test (
   tablename                   IN VARCHAR2
 ,  use_qualified_sql_name_in   IN BOOLEAN)
IS
   verify_tab   VARCHAR2 (64);
BEGIN
   DBMS_OUTPUT.put_line (
         'ASSERT result='
      || tablename
      || ' using '
      || CASE
            WHEN use_qualified_sql_name_in THEN 'qualified_sql_name'
            ELSE 'simple_sql_name'
         END);

   IF use_qualified_sql_name_in
   THEN
      verify_tab := DBMS_ASSERT.qualified_sql_name (tablename);
   ELSE
      verify_tab := DBMS_ASSERT.simple_sql_name (tablename);
   END IF;

   DBMS_OUTPUT.put_line (
      'SQL=select count(*) from all_tables where table_name=''' || verify_tab || '''');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (sys.DBMS_UTILITY.format_error_stack ());
END plch_injection_test;
/

BEGIN
   plch_injection_test ('CAT', TRUE);
END;
/

BEGIN
   plch_injection_test ('CAT'' or 1=1--', TRUE);
END;
/

BEGIN
   plch_injection_test ('"CAT'' or 1=1--"', TRUE);
END;
/

BEGIN
   plch_injection_test ('CAT', FALSE);
END;
/

BEGIN
   plch_injection_test ('CAT'' or 1=1--', FALSE);
END;
/

BEGIN
   plch_injection_test ('"CAT'' or 1=1--"', FALSE);
END;
/