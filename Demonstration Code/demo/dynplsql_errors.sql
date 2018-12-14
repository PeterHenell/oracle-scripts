CREATE OR REPLACE PROCEDURE dynplsql_test (n NUMBER)
IS
BEGIN
   RAISE NO_DATA_FOUND;
END;
/

BEGIN
   BEGIN                                                         -- PLS-00201
      EXECUTE IMMEDIATE 'begin BLAH.BLIP; end;';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;

   BEGIN                                                          -- PLS-00302
      EXECUTE IMMEDIATE 'begin qu_harness_xp.BLIP; end;';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;

   BEGIN                                                          -- PLS-00306
      EXECUTE IMMEDIATE 'begin qu_harness_xp.update_from_dict(TRUE); end;';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;

   BEGIN                                                          -- PLS-00306
      EXECUTE IMMEDIATE 'begin dynplsql_test(1); end;';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;
END;
/