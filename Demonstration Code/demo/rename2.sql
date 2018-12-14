DECLARE
   dir CONSTANT VARCHAR2(100) := 'e:\photos\childhouse';
   files PLVtab.vc2000_table;
   filenum PLS_INTEGER;
   renamed BOOLEAN;
BEGIN
   xfile.getdirContents (dir, files);
   filenum := files.FIRST;
   LOOP
      EXIT WHEN filenum IS NULL;
      renamed := xfile.rename (
         dir || '\' || files(filenum),
         dir || '\' || files(filenum) || '.jpg'
         );
      filenum := files.NEXT (filenum);
   END LOOP;
END;
/