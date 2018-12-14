SELECT *
  FROM user_plsql_object_settings p
 WHERE p.plsql_optimize_level < 2
/

SELECT DISTINCT name
  FROM all_plsql_object_settings ao
 WHERE owner = USER AND plscope_settings = 'IDENTIFIERS:ALL'
/