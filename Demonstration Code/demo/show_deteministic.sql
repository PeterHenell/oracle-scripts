SELECT object_name, procedure_name
  FROM all_procedures
 WHERE DETERMINISTIC = 'YES' AND owner = USER
/ 
