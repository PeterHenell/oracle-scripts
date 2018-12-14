DROP TABLE QNR_TESTCASE;

CREATE TABLE QNR_TESTCASE (
    NAME           VARCHAR2(100)
   ,object_name    VARCHAR2(200)
   ,SCHEMA         VARCHAR2(100)
   ,part1          VARCHAR2(100)
   ,part2          VARCHAR2(100)
   ,dblink         VARCHAR2(100)
   ,part1_type     NUMBER
   );

REM My control data for testing....

BEGIN
   INSERT INTO QNR_TESTCASE
        VALUES ('Table with schema', 'QNR_TEST.emp', 'QNR_TEST', 'EMP', NULL
               ,NULL, Qnr.c_table_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Table without schema', 'emp', 'QNR_TEST', 'EMP', NULL, NULL
               ,Qnr.c_table_type);

   INSERT INTO qnr_testcase
        VALUES ('View with schema', 'QNR_TEST.vemp', 'QNR_TEST', 'VEMP'
               ,NULL, NULL, Qnr.c_view_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Package with schema', 'QNR_TEST.pkg', 'QNR_TEST', 'PKG'
               ,NULL, NULL, Qnr.c_package_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Function with schema', 'QNR_TEST.func', 'QNR_TEST', NULL
               ,'FUNC', NULL, Qnr.c_function_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Procedure with schema', 'QNR_TEST.proc', 'QNR_TEST', NULL
               ,'PROC', NULL, Qnr.c_procedure_type);

   INSERT INTO QNR_TESTCASE
        VALUES ('Packaged procedure with schema', 'QNR_TEST.pkg.proc'
               ,'QNR_TEST', 'PKG', 'PROC', NULL, Qnr.c_package_type);

   -- c_package_type
   INSERT INTO QNR_TESTCASE
        VALUES ('Packaged procedure without schema', 'pkg.proc', 'QNR_TEST'
               ,'PKG', 'PROC', NULL, Qnr.c_package_type);

   COMMIT;
END;
/
