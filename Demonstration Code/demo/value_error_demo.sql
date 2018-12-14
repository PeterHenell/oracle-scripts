DECLARE
   PROCEDURE cause_value_error (code_in IN VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE code_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());
   END cause_value_error;
BEGIN
   cause_value_error
                  ('DECLARE l_number NUMBER; BEGIN l_number := ''abc''; END;');
   cause_value_error
                 ('DECLARE l_number NUMBER(2); BEGIN l_number := 12345; END;');
   cause_value_error
             ('DECLARE l_string VARCHAR2(1); BEGIN l_string := ''abc''; END;');
   cause_value_error
      ('DECLARE l_strings DBMS_SQL.VARCHAR2S; BEGIN l_strings('''') := 1; END;'
      );
END;
/