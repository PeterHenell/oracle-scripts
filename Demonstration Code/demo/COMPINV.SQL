DECLARE
   v_bad PLS_INTEGER;
   v_objtype VARCHAR2(200);

   CURSOR inv_cur IS   
      SELECT object_name, object_type
        FROM user_objects
       WHERE status = 'INVALID'
      ORDER BY object_type;

BEGIN
   SELECT COUNT(*) INTO v_bad
     FROM user_errors
    WHERE name LIKE 'PLV%' OR name = 'P';

   IF v_bad = 0
   THEN
      FOR rec IN inv_cur
      LOOP
         v_objtype := rec.object_type;

         IF rec.object_type = 'PACKAGE'
         THEN
            v_objtype := 'PACKAGE SPECIFICATION';
         END IF;

         DBMS_DDL.ALTER_COMPILE (v_objtype, USER, rec.object_name);
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('Compile errors found, so recompilation not performed.');
   END IF;

END;
/