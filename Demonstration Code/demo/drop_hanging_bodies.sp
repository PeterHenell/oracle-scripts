CREATE OR REPLACE PROCEDURE drop_dangling_bodies (nm IN VARCHAR2 default '%', test_only_in in boolean default false) AUTHID CURRENT_USER 
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  dropstr VARCHAR2(2000);

  CURSOR object_cur (spec_type_in in varchar2, body_type_in in varchar2)IS
    select object_name
      from user_objects
     where object_type = body_type_in
       and object_name like nm
    minus
    select object_name
      from user_objects
     where object_type = spec_type_in
       and object_name like nm;
procedure drop_type (spec_type_in in varchar2, body_type_in in varchar2) is
begin
  FOR rec IN object_cur (spec_type_in, body_type_in) LOOP
    dropstr := 'DROP ' || body_type_in || ' ' || rec.object_name;
  if test_only_in then
  DBMS_OUTPUT.put_line(dropstr || ' - VERIFICATION ONLY - NOT DROPPED!');
  else
    BEGIN
      EXECUTE IMMEDIATE dropstr;
      DBMS_OUTPUT.put_line(dropstr || ' - SUCCESSFUL!');
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(dropstr || ' - FAILURE!');
        DBMS_OUTPUT.put_line(DBMS_UTILITY.FORMAT_ERROR_STACK);
    END;end if;
  END LOOP; end drop_type;
BEGIN
drop_type ('PACKAGE', 'PACKAGE BODY');
drop_type ('TYPE', 'TYPE BODY');
END drop_dangling_bodies;
/
