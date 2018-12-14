SELECT table_name, trigger_type, triggering_event
  FROM user_triggers
 GROUP BY table_name, trigger_type, triggering_event
HAVING COUNT (*) > 1;

