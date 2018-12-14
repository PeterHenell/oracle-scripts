/*
Show the names of program units that reference tables 
(and which tables they are). Exclude TAPI columns.
*/

  SELECT name refs_table
       , TYPE program_unit
       , referenced_owner || '.' || referenced_name table_referenced
    FROM user_dependencies
   WHERE TYPE IN
            ('PACKAGE'
           , 'PACKAGE BODY'
           , 'PROCEDURE'
           , 'FUNCTION'
           , 'TRIGGER'
           , 'TYPE')
         AND referenced_type IN ('TABLE', 'VIEW')
         AND referenced_owner NOT IN ('SYS', 'SYSTEM')
         AND name NOT LIKE '%\_CP' ESCAPE '\'
         AND name NOT LIKE '%\_QP' ESCAPE '\'
         AND name NOT LIKE '%\_TP' ESCAPE '\'
ORDER BY name, referenced_owner, referenced_name
/