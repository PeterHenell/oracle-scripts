select object_name
  from user_objects
 where object_type = 'PACKAGE BODY'
minus
select object_name from user_objects where object_type = 'PACKAGE';
