DECLARE
   v_bad PLS_INTEGER;

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
         IF rec.object_type = 'PACKAGE'
         THEN
            rec.object_type := 'PACKAGE SPECIFICATION';
         END IF;
         DBMS_DDL.ALTER_COMPILE (rec.object_type, USER, rec.object_name);
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('Compile errors found, so recompilation not performed.');
   END IF;

END;
/