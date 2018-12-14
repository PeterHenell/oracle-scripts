SELECT   AUTHID
       , p.object_name program_name
       , procedure_name subprogram_name
    FROM all_procedures p, all_objects o
   WHERE p.owner = o.owner
     AND p.object_name = o.object_name
     AND p.object_name LIKE '&1'
ORDER BY AUTHID, procedure_name;