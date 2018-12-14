CREATE OR REPLACE PROCEDURE setcons (
   tab IN VARCHAR2,
   action IN VARCHAR2,
   sch IN VARCHAR2 := NULL
)
IS
   v_action VARCHAR2 (10) := UPPER (action);
   v_other_action VARCHAR2 (10) := 'DISABLED';
BEGIN
   IF v_action = 'DISABLE'
   THEN
      v_other_action := 'ENABLED';
   END IF;

   FOR rec IN
      (SELECT constraint_name,
              'ALTER TABLE ' || owner || '.' || table_name ||
                 ' ' ||
                 v_action ||
                 ' CONSTRAINT ' ||
                 constraint_name command
         FROM all_constraints
        WHERE owner = NVL (UPPER (sch), USER)
          AND table_name = UPPER (tab)
          AND status = v_other_action)
   LOOP
      EXECUTE IMMEDIATE rec.command;
      DBMS_OUTPUT.PUT_LINE (
         'Set status of ' || rec.constraint_name || ' to ' ||
            v_action
      ); 
   END LOOP;
END;
/   
