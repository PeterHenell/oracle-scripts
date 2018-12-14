/*
It doesn't hurt to ASK your DBA
to run this script for your schema!
:-)
*/
GRANT SELECT ON v_$session TO &1;
GRANT SELECT ON v_$sqlarea TO &1;
GRANT SELECT ON v_$open_cursor TO &1;
GRANT SELECT ON v_$sqltext TO &1;
GRANT SELECT ON v_$sqltext_with_newlines TO &1;
GRANT SELECT ON v_$session_longops TO &1;
GRANT SELECT ON v_$sesstat TO &1;
GRANT SELECT ON v_$statname TO &1;
GRANT SELECT ON v_$mystat TO &1;
GRANT SELECT ON v_$db_pipes TO &1;
GRANT SELECT ON v_$db_object_cache TO &1;
GRANT SELECT ON v_$access TO &1;
GRANT SELECT ON v_$parameter TO &1;
GRANT SELECT ON dba_object_size TO &1;
GRANT SELECT ON dba_keepsizes TO &1;
GRANT SELECT ON obj$ TO &1;
GRANT SELECT ON user$ TO &1;
GRANT SELECT ON code_size TO &1;
GRANT SELECT ON parsed_size TO &1;
GRANT SELECT ON v_$db_object_cache TO &1;
GRANT SELECT ON v_$rowcache TO &1;
GRANT SELECT ON v_$librarycache TO &1;
GRANT CREATE ANY DIRECTORY TO &1;
GRANT SELECT ON v_$sys_time_model TO &1;
GRANT SELECT ON v_$sql TO &1;
GRANT SELECT ON v_$reserved_words to &1;
GRANT SELECT ON v_$result_cache_dependency to &1;
GRANT SELECT ON v_$result_cache_objects to &1;
