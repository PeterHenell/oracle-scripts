SELECT DISTINCT
       CASE package_name WHEN NULL THEN NULL ELSE package_name || '.' END
       || object_name
  FROM user_arguments
 WHERE data_type = 'CHAR'
/