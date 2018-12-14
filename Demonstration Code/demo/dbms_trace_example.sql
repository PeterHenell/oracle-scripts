BEGIN
   DBMS_TRACE.set_plsql_trace (DBMS_TRACE.trace_all_lines);
   intab ('DEPARTMENTS');
   DBMS_TRACE.clear_plsql_trace;
END;
/