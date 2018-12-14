  SELECT *
    FROM all_arguments
   WHERE owner = USER AND package_name = UPPER ('&1')
ORDER BY owner
       , package_name
       , object_name
       , overload
       , position
       , data_level;