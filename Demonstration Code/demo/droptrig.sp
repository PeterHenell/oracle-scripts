CREATE OR REPLACE PROCEDURE drop_triggers (tab IN VARCHAR2
                                         , sch IN VARCHAR2 DEFAULT NULL
                                          )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   FOR rec
      IN (SELECT trigger_name
            FROM user_triggers
           WHERE table_owner = UPPER (NVL (sch, USER)) AND table_name = tab)
   LOOP
      EXECUTE IMMEDIATE 'DROP TRIGGER ' || rec.trigger_name;

      DBMS_OUTPUT.put_line ('Dropped trigger ' || rec.trigger_name);
   END LOOP;
END drop_triggers;
/

BEGIN
   drop_triggers ('EMPLOYEES');
END;
/