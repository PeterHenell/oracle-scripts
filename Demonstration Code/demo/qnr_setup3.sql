REM Add more test cases to test wider variety of circumstances.

BEGIN
   INSERT INTO qnr_testcase
        VALUES ('Object type with schema', 'QNR_TEST.objt', 'QNR_TEST'
               ,'OBJT', NULL, NULL, 13);

   INSERT INTO qnr_testcase
        VALUES ('Local synonym for table', 'ls_emp', 'QNR_TEST', 'EMP', NULL
               ,NULL, Qnr.c_table_type);

   INSERT INTO qnr_testcase
        VALUES ('Local synonym for package', 'ls_pkg', 'QNR_TEST', 'PKG'
               ,NULL, NULL, Qnr.c_package_type);

   INSERT INTO qnr_testcase
        VALUES ('Public synonym for table', 'ps_emp', 'QNR_TEST', 'EMP'
               ,NULL, NULL, Qnr.c_table_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Public synonym for package', 'ps_pkg', 'QNR_TEST', 'PKG'
               ,NULL, NULL, Qnr.c_package_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Public synonym for local synonym of package', 'ps_ls_pkg', 'QNR_TEST', 'PKG'
               ,NULL, NULL, Qnr.c_package_type);
			   
   INSERT INTO QNR_TESTCASE
        VALUES ('Public synonym for public synonym of package', 'ps_ps_pkg', 'QNR_TEST', 'PKG'
               ,NULL, NULL, Qnr.c_package_type);
			   
   COMMIT;
END;
/
