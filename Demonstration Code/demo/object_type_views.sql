SELECT *
  FROM all_type_methods
 WHERE owner = USER AND type_name = 'TMR_T'
/
SELECT *
  FROM all_method_params
 WHERE owner = USER AND type_name = 'TMR_T'
/
SELECT *
  FROM all_method_results
 WHERE owner = USER AND type_name = 'TMR_T' AND method_name = 'MAKE'
/
