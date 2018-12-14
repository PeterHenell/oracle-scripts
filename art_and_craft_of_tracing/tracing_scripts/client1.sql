begin
dbms_monitor.CLIENT_ID_TRACE_ENABLE (
 CLIENT_ID => 'CLIENT1',
 WAITS => TRUE,
 BINDS => FALSE
);
end;
/
