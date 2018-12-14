-- Synonyms
GRANT SELECT ON EMP TO PUBLIC;

CREATE SYNONYM qnr_test.ls_emp FOR qnr_test.EMP;

GRANT SELECT ON vemp TO PUBLIC;

CREATE SYNONYM qnr_test.ls_vemp FOR qnr_test.vemp;

GRANT SELECT ON DEPT TO PUBLIC;

CREATE SYNONYM qnr_test.ls_dept FOR qnr_test.DEPT;

GRANT EXECUTE ON Pkg TO PUBLIC;

CREATE SYNONYM qnr_test.ls_pkg FOR qnr_test.Pkg;

GRANT EXECUTE ON Proc TO PUBLIC;

CREATE SYNONYM qnr_test.ls_proc FOR qnr_test.Proc;

GRANT EXECUTE ON Func TO PUBLIC;

CREATE SYNONYM qnr_test.ls_func FOR qnr_test.Func;

GRANT EXECUTE ON objt TO PUBLIC;

CREATE SYNONYM qnr_test.ls_objt FOR qnr_test.objt;

-- PUBLIC synonyms

CREATE OR REPLACE PUBLIC SYNONYM ps_emp FOR qnr_test.EMP;

CREATE OR REPLACE PUBLIC SYNONYM ps_vemp FOR qnr_test.vemp;

CREATE OR REPLACE PUBLIC SYNONYM ps_dept FOR qnr_test.DEPT;

CREATE OR REPLACE PUBLIC SYNONYM ps_pkg FOR qnr_test.Pkg;

CREATE OR REPLACE PUBLIC SYNONYM ps_proc FOR qnr_test.Proc;

CREATE OR REPLACE PUBLIC SYNONYM ps_func FOR qnr_test.Func;

CREATE OR REPLACE PUBLIC SYNONYM ps_objt FOR qnr_test.objt;

-- synonyms for synonyms

CREATE SYNONYM qnr_test.ls_ls_emp FOR qnr_test.ls_emp;

CREATE SYNONYM qnr_test.ls_ls_vemp FOR qnr_test.ls_vemp;

CREATE SYNONYM qnr_test.ls_ls_dept FOR qnr_test.ls_dept;

CREATE SYNONYM qnr_test.ls_ls_pkg FOR qnr_test.ls_pkg;

CREATE SYNONYM qnr_test.ls_ls_proc FOR qnr_test.ls_proc;

CREATE SYNONYM qnr_test.ls_ls_func FOR qnr_test.ls_func;

CREATE SYNONYM qnr_test.ls_ls_objt FOR qnr_test.ls_objt;

-- PUBLIC synonyms for PUBLIC synonyms

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_emp FOR ps_emp;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_vemp FOR ps_vemp;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_dept FOR ps_dept;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_pkg FOR ps_pkg;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_proc FOR ps_proc;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_func FOR ps_func;

CREATE OR REPLACE PUBLIC SYNONYM ps_ps_objt FOR ps_objt;

-- synonyms for PUBLIC synonyms

CREATE SYNONYM qnr_test.ls_ps_emp FOR ps_emp;

CREATE SYNONYM qnr_test.ls_ps_vemp FOR ps_vemp;

CREATE SYNONYM qnr_test.ls_ps_dept FOR ps_dept;

CREATE SYNONYM qnr_test.ls_ps_pkg FOR ps_pkg;

CREATE SYNONYM qnr_test.ls_ps_proc FOR ps_proc;

CREATE SYNONYM qnr_test.ls_ps_func FOR ps_func;

CREATE SYNONYM qnr_test.ls_ps_objt FOR ps_objt;

-- PUBLIC synonyms for synonyms

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_emp FOR qnr_test.ls_emp;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_vemp FOR qnr_test.ls_vemp;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_dept FOR qnr_test.ls_dept;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_pkg FOR qnr_test.ls_pkg;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_proc FOR qnr_test.ls_proc;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_func FOR qnr_test.ls_func;

CREATE OR REPLACE PUBLIC SYNONYM ps_ls_objt FOR qnr_test.ls_objt;

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

