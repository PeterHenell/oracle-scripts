SELECT DISTINCT
       CASE WHEN package_name 
                 IS NULL THEN NULL 
       ELSE package_name || '.' END
       || object_name
  FROM user_arguments
 WHERE data_type = 'CHAR'
/