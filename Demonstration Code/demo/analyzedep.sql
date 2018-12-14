DECLARE
/* Author: Steven Feuerstein */

/* Generate dependencies for all specified objects in the current schema */

   CURSOR obj_cur 
   IS
      SELECT object_name FROM USER_OBJECTS 
       WHERE object_name LIKE UPPER ('&&firstparm')
         AND object_type NOT IN ('TABLE', 'VIEW');
BEGIN
   FOR obj_r IN obj_cur
   LOOP
      getalldeps (obj_r.object_name);
   END LOOP;
END;
/

BEGIN

/* Generate summarized information */

   DELETE FROM depsummary;
     
   FOR rec IN (SELECT DISTINCT name 
                 FROM alldeps
                WHERE owner = USER
                  AND name LIKE UPPER('&&firstparm'))
   LOOP
      INSERT INTO depsummary
      SELECT USER,
             rec.name,
             COUNT(DISTINCT refname),
             SUM (source_size),
             SUM (parsed_size),
             SUM (code_size)
        FROM (SELECT DISTINCT refowner, refname 
                FROM alldeps
               WHERE owner = USER 
                 AND name = rec.name) D, 
             (SELECT owner, name, 
                     SUM (source_size) source_size,
                     SUM (parsed_size) parsed_size, 
                     SUM (code_size) code_size  
                FROM dba_object_size 
               GROUP BY owner, name) S
       WHERE D.refowner = S.owner
         AND D.refname = S.name;
   END LOOP;
   COMMIT; 
END;
/

             