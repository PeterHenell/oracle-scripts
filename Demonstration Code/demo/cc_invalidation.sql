SET FEEDBACK OFF

CREATE OR REPLACE PACKAGE static_constant
IS
   c_number   CONSTANT PLS_INTEGER := 1;
   c_other   CONSTANT PLS_INTEGER := 1;
END;
/

CREATE OR REPLACE PROCEDURE use_static_constant
IS
BEGIN
   $IF static_constant.c_number = 1
   $THEN
      DBMS_OUTPUT.put_line ('Constant = 1');
   $ELSE
      DBMS_OUTPUT.put_line ('Constant <> 1');
   $END
END;
/

SELECT 'Initial status = ' || status
  FROM user_objects
 WHERE object_name = 'USE_STATIC_CONSTANT'
/

CREATE OR REPLACE PACKAGE static_constant
IS
   c_number   CONSTANT PLS_INTEGER := 2;
   c_other   CONSTANT PLS_INTEGER := 1;
END;
/

SELECT 'After change value of referenced constant = ' || status
  FROM user_objects
 WHERE object_name = 'USE_STATIC_CONSTANT'
/

alter procedure USE_STATIC_CONSTANT compile reuse settings
/

SELECT 'After recompile = ' ||status
  FROM user_objects
 WHERE object_name = 'USE_STATIC_CONSTANT'
/

CREATE OR REPLACE PACKAGE static_constant
IS
   c_number   CONSTANT PLS_INTEGER := 2;
   c_other   CONSTANT PLS_INTEGER := 2;
END;
/

SELECT 'After change value of unreferenced constant = ' ||status
  FROM user_objects
 WHERE object_name = 'USE_STATIC_CONSTANT'
/