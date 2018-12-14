DECLARE
   sch             VARCHAR2 (100);
   part1           VARCHAR2 (100);
   part2           VARCHAR2 (100);
   dblink          VARCHAR2 (100);
   part1_type      NUMBER;
   object_number   NUMBER;
BEGIN
   DBMS_UTILITY.name_resolve ('&1'
                             ,1
                             ,sch
                             ,part1
                             ,part2
                             ,dblink
                             ,part1_type
                             ,object_number
                             );
  p.l (sch);
  p.l (part1);
  p.l (part2);
  p.l (part1_type); 							 
END;
/
