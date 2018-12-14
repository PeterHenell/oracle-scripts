DECLARE
   l   PLS_INTEGER;
BEGIN
   DELETE FROM msg_info;

   drop_whatever ('PARTS%', 'TABLE');

   SELECT COUNT (*)
     INTO l
     FROM msg_info;

   p.l (l);
   ROLLBACK;

   SELECT COUNT (*)
     INTO l
     FROM msg_info;

   p.l (l);
/*
DROP TABLE PARTS CASCADE CONSTRAINTS - SUCCESSFUL!
DROP TABLE PARTS2 CASCADE CONSTRAINTS - SUCCESSFUL!
0
2
*/   
END;
/