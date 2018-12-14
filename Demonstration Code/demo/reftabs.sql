SELECT owner || '.' || name refs_table,
       referenced_owner || '.' || referenced_name table_referenced
  FROM all_dependencies
 WHERE owner LIKE UPPER ('SCOTT')
   AND TYPE IN (
                  'PACKAGE',
                  'PACKAGE BODY',
                  'PROCEDURE',
                  'FUNCTION'
               )
   AND referenced_type IN ('TABLE', 'VIEW')
   AND referenced_owner NOT IN ('SYS', 'SYSTEM') 
 ORDER BY owner,
          name,
          referenced_owner,
          referenced_name;