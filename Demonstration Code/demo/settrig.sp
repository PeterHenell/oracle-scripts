CREATE OR REPLACE PROCEDURE settrig (
   tab      IN   VARCHAR2
 , sch      IN   VARCHAR DEFAULT NULL
 , action   IN   VARCHAR2
)
IS
   l_action         VARCHAR2 (10) := UPPER (action);
   l_other_action   VARCHAR2 (10) := 'DISABLED';
BEGIN
   IF l_action = 'DISABLE'
   THEN
      l_other_action := 'ENABLED';
   END IF;

   FOR rec IN (SELECT trigger_name
                 FROM user_triggers
                WHERE table_owner = UPPER (NVL (sch, USER))
                  AND table_name = tab
                  AND status = l_other_action)
   LOOP
      EXECUTE IMMEDIATE 'ALTER TRIGGER ' || rec.trigger_name || ' '
                        || l_action;

      DBMS_OUTPUT.put_line (   'Set status of '
                            || rec.trigger_name
                            || ' to '
                            || l_action
                           );
   END LOOP;
END settrig;
/
