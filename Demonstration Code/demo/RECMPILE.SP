CREATE OR REPLACE PROCEDURE recompile 
/*
   The reason you might want to use this (or the even more sophisticated
   version in the PL/SQL Pipeline Archives) intead of DBMS_UTILITY.COMPILE_SCHEMA:

SQL> select count(*) from user_objects where status='INVALID';

  COUNT(*)
----------
        87

1 row selected.

SQL> exec dbms_utility.compile_schema (user)

PL/SQL procedure successfully completed.

SQL>  select count(*) from user_objects where status='INVALID';

  COUNT(*)
----------
        47
        
*/
IS
   CURSOR obj_cur IS   
      SELECT owner, object_name, 
             DECODE (object_type, 'PACKAGE', 'PACKAGE SPECIFICATION') object_type
        FROM ALL_OBJECTS
       WHERE object_name LIKE UPPER (name_in)
         AND object_type LIKE UPPER (type_in)
         AND owner LIKE UPPER (schema_in)
			AND status = 'INVALID'
      ORDER BY 
         DECODE (object_type, 
            'PACKAGE', 1, 'PACKAGE BODY', 4,
            'FUNCTION', 2, 'PROCEDURE', 3);

   myvar VARCHAR2(2000) := 'abc';
BEGIN
   FOR rec IN obj_cur
   LOOP
      DBMS_DDL.ALTER_COMPILE (v_objtype, rec.owner, rec.object_name); 

      DBMS_OUTPUT.PUT_LINE 
         ('Compiled ' || v_objtype || ' of ' || 
          rec.owner || '.' || rec.object_name);  
   END LOOP;
END;
/