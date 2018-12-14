ALTER SESSION SET PLSQL_CCFLAGS = 'vl_trace_level:1,vl_trace_program:123'
/

CREATE OR REPLACE PROCEDURE vl_validate_choices
IS
BEGIN
$IF vl_trace.trace_enabled AND $$vl_trace_program = 123
$THEN
   DBMS_OUTPUT.PUT_LINE ('Summary information here...');
   $IF $$vl_trace_level = 1
   $THEN
      DBMS_OUTPUT.PUT_LINE ('Detailed information here...');
   $END
$END
   NULL;
END;   
/
