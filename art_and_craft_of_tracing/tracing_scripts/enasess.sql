begin
  dbms_monitor.session_trace_enable (
    session_id => 255,
    serial_num => 173,
    waits      => true,
    binds      => true,
    plan_stat  => 'all_executions');
end;
/
