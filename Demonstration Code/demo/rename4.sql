DECLARE
   dir CONSTANT VARCHAR2(100) := 'd:\demo\temp';
   files PLVtab.vc2000_table;
   filenum PLS_INTEGER;
   renamed BOOLEAN;
BEGIN
   xfile.getdirContents (dir, 'xxxv%', files, FALSE);
   filenum := files.FIRST;
   LOOP
      EXIT WHEN filenum IS NULL;
      renamed := xfile.rename (
         dir || '\' || files(filenum),
         dir || '\' || 'xxx' || SUBSTR (files(filenum), 5)
         );
      filenum := files.NEXT (filenum);
   END LOOP;
END;
/