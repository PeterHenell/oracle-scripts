CREATE OR REPLACE PROCEDURE drop_policies (
   objname IN VARCHAR2,
   polname IN VARCHAR2 := '%',
   objschema IN VARCHAR2 := NULL)
   AUTHID CURRENT_USER
IS
BEGIN
   FOR rec IN (
      SELECT object_owner, 
             object_name, 
             policy_name
        FROM ALL_POLICIES
       WHERE object_owner LIKE NVL (objschema, USER)
         AND object_name LIKE objname
         AND policy_name LIKE polname)
   LOOP
      BEGIN
         DBMS_RLS.DROP_POLICY (
            rec.object_owner, rec.object_name, rec.policy_name);
            
         DBMS_OUTPUT.PUT_LINE (
            'Dropped policy ' || rec.policy_name
            );
      EXCEPTION
         WHEN OTHERS 
         THEN 
            DBMS_OUTPUT.PUT_LINE (
               'Error encountered trying to drop policy ' ||
               rec.policy_name ||':' || SQLERRM);
      END;
   END LOOP;
END;
/
   
   
   