SET SERVEROUTPUT ON FORMAT WRAPPED

SET LINESIZE 300

BEGIN
   /* Compile betwnstr.sf files. */
   gen_trace_call ('BETWNSTR');
END;
/