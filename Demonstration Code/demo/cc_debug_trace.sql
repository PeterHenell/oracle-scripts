ALTER SESSION SET PLSQL_CCFLAGS = 
     'oe_debug:true, oe_trace_level:10, commit_OFF:true'
/

CREATE OR REPLACE PROCEDURE calculate_totals
IS
BEGIN
$IF $$oe_debug AND $$oe_trace_level >= 5
$THEN
   -- q$error_manager.trace ...
   DBMS_OUTPUT.PUT_LINE ('Tracing at level 5 or higher');
$END            
   NULL;
$IF $$commit_off
$THEN
   /* Commit disabled! */
$ELSE
   COMMIT;
$END   
END calculate_totals;
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PROCEDURE', USER, 'CALCULATE_TOTALS');
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = 'oe_debug:false'
/

ALTER PROCEDURE calculate_totals COMPILE
/

BEGIN
   dbms_preprocessor.print_post_processed_source (
      'PROCEDURE', USER, 'CALCULATE_TOTALS');
END;
/