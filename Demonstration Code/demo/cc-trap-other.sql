ALTER SESSION SET PLSQL_CCFLAGS = 'current_user_type:1'
/
  
CREATE OR REPLACE PACKAGE user_types
IS
   administrator CONSTANT PLS_INTEGER := 1;
   enduser CONSTANT PLS_INTEGER := 2;
END user_types;
/

CREATE OR REPLACE PROCEDURE show_info
IS
BEGIN
$IF $$current_user_type = user_types.administrator
$THEN
   DBMS_OUTPUT.PUT_LINE ('Administrator!');
$ELSIF $$current_user_type = user_types.enduser
$THEN
   DBMS_OUTPUT.PUT_LINE ('End user!');
$ELSE
   $ERROR 'Current user type of ' || $$current_user_type || ' is not known.' $END
$END
END show_info;
/

ALTER PROCEDURE show_info COMPILE
  PLSQL_CCFLAGS = 'current_user_type:0'
  REUSE SETTINGS
/
