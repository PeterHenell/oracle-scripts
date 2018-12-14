SELECT ua.object_name,
       ua.package_name,
       ua.argument_name,
       ua.in_out
  FROM (SELECT *
          FROM user_arguments
         WHERE position = 0) f,
       user_arguments ua
 WHERE     ua.in_out IN ('OUT', 'IN OUT')
       AND ua.position > 0
       AND ua.data_level = 0
       AND f.object_name = ua.object_name
       AND f.package_name = ua.package_name
       AND (   f.overload = ua.overload
            OR (f.overload IS NULL 
                 AND ua.overload IS NULL))
/                 