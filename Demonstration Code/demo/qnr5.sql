BEGIN
   DELETE FROM qnr_testcase
         WHERE NAME = 'Object type with schema';

   INSERT INTO qnr_testcase
        VALUES ('Object type with schema', 'QNR_TEST.objt', 'QNR_TEST'
               ,'OBJT', NULL, NULL, 13);
END;
/

@@qnr.pks
@@qnr.pkb