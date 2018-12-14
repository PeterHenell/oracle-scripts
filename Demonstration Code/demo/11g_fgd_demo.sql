set serveroutput on format wrapped

CREATE OR REPLACE PROCEDURE show_status (s IN VARCHAR2
                                       , n IN VARCHAR2
                                       , t IN VARCHAR2
                                       , title IN VARCHAR2 DEFAULT NULL
                                        )
IS
   l_status   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_status
     FROM all_objects
    WHERE owner = s AND object_name = n AND object_type = t;

   DBMS_OUTPUT.put_line ('Status of ' || t || ' ' || s || '.' || n);

   IF title IS NOT NULL
   THEN
      DBMS_OUTPUT.put_line (title);
   END IF;

   DBMS_OUTPUT.put_line (l_status);
END show_status;
/

CREATE OR REPLACE PACKAGE magic_value
IS
   c_value1   NUMBER := 1;
END;
/

CREATE OR REPLACE PROCEDURE use_magic_value
IS
BEGIN
   DBMS_OUTPUT.put_line (magic_value.c_value1);
END;
/

BEGIN
   show_status (USER, 'USE_MAGIC_VALUE', 'PROCEDURE', 'Initial Compile');
END;
/

CREATE OR REPLACE PACKAGE magic_value
IS
   c_value1   NUMBER := 2;
END;
/

BEGIN
   show_status (USER
              , 'USE_MAGIC_VALUE'
              , 'PROCEDURE'
              , 'Change packaged constant value'
               );
END;
/

/*
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0
Connected as patrick
SQL>
Procedure created
Package created
Procedure created
Status of PROCEDURE PATRICK.USE_MAGIC_VALUE
Initial Compile
VALID
PL/SQL procedure successfully completed
Package created
Status of PROCEDURE PATRICK.USE_MAGIC_VALUE
Change packaged constant value
INVALID
*/