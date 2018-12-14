DECLARE
   SCHEMA       VARCHAR2 (100);
   part1        VARCHAR2 (100);
   part2        VARCHAR2 (100);
   dblink       VARCHAR2 (100);
   nextpos      BINARY_INTEGER;
   a            VARCHAR2 (400)    := '&&firstparm';
BEGIN
   DBMS_UTILITY.name_tokenize (a, SCHEMA, part1, part2, dblink, nextpos);
   p.l (SCHEMA);
   p.l (part1);
   p.l (part2);
   p.l (dblink);
   p.l (nextpos);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLCODE);
END;
/