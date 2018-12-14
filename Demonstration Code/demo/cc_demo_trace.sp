CREATE OR REPLACE PROCEDURE demo_tracing (value_in IN VARCHAR2)
IS
BEGIN
   $IF cc_trace.trace_enabled
   $THEN
      DBMS_OUTPUT.PUT_LINE ('Trace enabled for $$PLSQL_UNIT, called with value_in = ' || value_in);
   $END
   
   DBMS_OUTPUT.PUT_LINE ('EXECUTE DEMO_TRACING BODY');
   
   IF value_in = 'RAISE' 
   THEN
      RAISE PROGRAM_ERROR;
   END IF;    
EXCEPTION
   WHEN OTHERS
   THEN
      $IF cc_trace.trace_enabled
      $THEN
         DBMS_OUTPUT.PUT_LINE ('Error executing $$PLSQL_UNIT, called with value_in = ' || value_in);
         DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);         
      $END    
      RAISE;     
END;
/
