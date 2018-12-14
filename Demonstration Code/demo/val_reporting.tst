SET SERVEROUTPUT ON

ALTER SESSION SET PLSQL_CCFLAGS = 'val_testing_enabled_:true'
/

ALTER PACKAGE val_reporting COMPILE
/

BEGIN
    val_reporting.test_choices_report;
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'val_testing_enabled_:false'
/

ALTER PACKAGE val_reporting COMPILE
/

BEGIN
    val_reporting.test_choices_report;
END;
/
	 
