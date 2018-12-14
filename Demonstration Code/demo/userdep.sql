select referenced_owner || '.' || referenced_name 
  from user_dependencies
 where name='SHOWEMPS'
/
