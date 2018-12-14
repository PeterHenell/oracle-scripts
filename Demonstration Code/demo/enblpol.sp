CREATE OR REPLACE PROCEDURE set_policy (
   objname IN VARCHAR2,
   polname IN VARCHAR2 := '%',
   enable IN BOOLEAN := TRUE,
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
      DBMS_RLS.ENABLE_POLICY (
         rec.object_owner, rec.object_name, rec.policy_name, enable);
   END LOOP;
END;
/
   
   
   