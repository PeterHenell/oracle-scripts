SET SERVEROUTPUT ON

ALTER SESSION SET PLSQL_CCFLAGS = 'mock_case_1:false, mock_case_2:false'
/

ALTER FUNCTION my_function COMPILE
/

BEGIN
    my_procedure;
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'mock_case_1:true, mock_case_2:false'
/

ALTER FUNCTION my_function COMPILE
/

BEGIN
    my_procedure;
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'mock_case_1:false, mock_case_2:true'
/

ALTER FUNCTION my_function COMPILE
/

BEGIN
    my_procedure;
END;
/